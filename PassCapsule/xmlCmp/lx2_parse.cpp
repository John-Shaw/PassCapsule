/* ****************************************************************************
 * lx2_parse.cpp : parsing xmldiff commands                                   *
 * -------------------------------------------------------------------------- *
 *                                                                            *
 * Copyright (C) 2004 - R�mi Peyronnet <remi+xmldiff@via.ecp.fr>              *
 *                                                                            *
 * This program is free software; you can redistribute it and/or              *
 * modify it under the terms of the GNU General Public License                *
 * as published by the Free Software Foundation; either version 2             *
 * of the License, or (at your option) any later version.                     *
 *                                                                            *
 * This program is distributed in the hope that it will be useful,            *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 * GNU General Public License for more details.                               *
 *                                                                            *
 * You should have received a copy of the GNU General Public License          *
 * along with this program; if not, write to the Free Software                *
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.*
 * http://www.gnu.org/copyleft/gpl.html                                       *
 * ************************************************************************** */

#include "libxmldiff.h"
#include "lx2_parse.h"
#include "errors.h"

#include <iostream>
#include <fstream>

// If stricmp is not supported, just replace it... (only used in command line)
#ifndef stricmp
#define stricmp strcmp
#endif

/** parseOption : parse option item
 * @param option the option
 * @param arg the option argument (must be empty if none)
 * @param opt [in, out] the structure that contains the result options
 * @return the number of element taken :
 *          0 if an error has occured
 *          1 if only the option was taken
 *          2 if the argument was usefull
 */
int parseOption(const string & option, const string & arg, /* [in, out] */ struct globalOptions & opt)
{
    bool argBool;
    int status;

    // Usefull Macros
    #define OPT_MATCH(x) (stricmp(option.c_str(), x) == 0)
    #define ARG_MATCH(x) (stricmp(arg.c_str(), x) == 0)
    #define ONE status = 1;
    #define TWO if (arg == "") { throwError(XD_Exception::XDE_MISSING_ARG, "Missing argument to option '%s'.", option.c_str()); } else status = 2;

    status = 0;
    argBool = false;
    if (ARG_MATCH("yes") || ARG_MATCH("1") || ARG_MATCH("oui")) argBool = true;

    // Separators --sep
    if OPT_MATCH("--sep") { TWO; opt.separator = BAD_CAST arg.c_str(); }
    // Before Values --before-values
    else if OPT_MATCH("--before-values") { TWO; opt.beforeValue = argBool;  }
    // Pretty Print --pretty-print
    else if OPT_MATCH("--pretty-print")  { TWO; opt.formatPrettyPrint = argBool;  }
    // No Blanks --no-blanks
    else if OPT_MATCH("--no-blanks") { TWO; opt.cleanText = argBool; }
    // Force Clean --force-clean
    else if OPT_MATCH("--force-clean") { TWO; opt.forceClean = argBool; }
    // Tag Childs --tag-childs
    else if OPT_MATCH("--tag-childs")  { TWO; opt.tagChildsAddedRemoved = argBool; }
    // Optimize --optimize
    else if OPT_MATCH("--optimize")  { TWO; opt.optimizeMemory = argBool; }
    // Diff Only --diff-only
    else if OPT_MATCH("--diff-only")  { TWO; opt.diffOnly = argBool; }
#ifndef WITHOUT_LIBXSLT
    // Use EXSLT --use-exslt
    else if OPT_MATCH("--use-exslt")  { TWO; opt.useEXSLT = argBool; }
#endif // WITHOUT_LIBXSLT
    // Automatic Save
    else if OPT_MATCH("--auto-save")  { TWO; opt.automaticSave = argBool; }
    // Verbose Level
    else if (OPT_MATCH("--verbose") || OPT_MATCH("-v"))
    { 
        TWO; 
        sscanf(arg.c_str(), "%d", &opt.verboseLevel);
    }
    // Ids --ids & -i
    else if (OPT_MATCH("--ids") || OPT_MATCH("-i"))
    { 
        TWO;
        // Ids Splitting
        int pos, oldpos;
        oldpos = pos = 0;
        opt.ids.clear();
        while((pos = arg.find(',', pos+1)) > 0)
        {
            opt.ids.push_back(xmlstring(BAD_CAST arg.substr(oldpos, pos-oldpos).c_str()));
            oldpos = pos + 1;
        }
        if (oldpos < arg.size()) opt.ids.push_back(xmlstring(BAD_CAST arg.substr(oldpos, oldpos-arg.size()).c_str()));
    }

    #undef OPT_MATCH
    #undef ARG_MATCH
    #undef ONE
    #undef TWO

    return status;
}

/** parseAction : parse action item
 * @param action string containing the action
 * @param cmd command structure
 * @return 0 if no error happened
 * @note Set default values for actions
 */
int parseAction(string action, struct appCommand & cmd)
{
    #define ACTION_MATCH(x) (stricmp(action.c_str(), x) == 0)

    // Default value
    cmd.action = XD_NONE;
    // Empty parameters.
    cmd.param1 = "";
    cmd.param2 = "";
    cmd.param3 = "";
    cmd.param4 = "";
    cmd.param5 = "";
    cmd.param6 = "";
    cmd.param7 = "";
    cmd.param8 = "";
    cmd.param9 = "";

    // Parse
    if ACTION_MATCH("help")  cmd.action = XD_HELP;
    else if ACTION_MATCH("diff") 
    {
        cmd.param1 = "before.xml";
        cmd.param2 = "after.xml";
        cmd.param3 = "output.xml";
        cmd.action = XD_DIFF;
    }
    else if ACTION_MATCH("recalc") 
    {
        cmd.param1 = "output.xml";
        cmd.action = XD_RECALC;
    }
    else if ACTION_MATCH("execute")
    {
        cmd.param1 = "xmldiff.txt";
        cmd.action =  XD_EXECUTE;
    }
#ifndef WITHOUT_LIBXSLT
    else if ACTION_MATCH("xslt")
    {
        cmd.param1 = "style.xsl";
        cmd.param1 = "input.xml";
        cmd.param3 = "output.xml";
        cmd.action =  XD_XSLT;
    }
#endif // WITHOUT_LIBXSLT
    else if ACTION_MATCH("load") cmd.action =  XD_LOAD;
    else if ACTION_MATCH("save") cmd.action =  XD_SAVE;
    else if ACTION_MATCH("close") cmd.action =  XD_CLOSE;
    else if ACTION_MATCH("discard")
    {
        cmd.automaticSave = false;
        cmd.action =  XD_DISCARD;
    }
    else if ACTION_MATCH("flush") cmd.action =  XD_FLUSH;
    else if ACTION_MATCH("options") cmd.action =  XD_OPTIONS;
    else if ACTION_MATCH("print_configuration") cmd.action =  XD_PRINTCONF;
    else if ACTION_MATCH("print") cmd.action =  XD_PRINT;
    else if ACTION_MATCH("delete") cmd.action =  XD_DELETE;
    else if ACTION_MATCH("dup") cmd.action =  XD_DUP;
    else if (ACTION_MATCH("remark") || 
             ACTION_MATCH("rem") ||
             ACTION_MATCH("#") ||
             ACTION_MATCH("//") ||
             ACTION_MATCH("--"))    cmd.action =  XD_REM;
    else throwError(XD_Exception::XDE_UNKNOWN_COMMAND, "Unknown command '%s'.", action.c_str());

    return 0;
    #undef ACTION_MATCH
}

/** parseCommandLine : parse command line
 * @param cl arguments vector
 * @param appOptions [in, out] the structure that contains the result options
 * @return status code : 0 means no error
 */
int parseCommandLine(const vector<string> & cl, /* [in, out] */ struct appCommand & opt)
{
    int curarg;
    int nArgOther;
    int ret;

    #define ARG_MATCH(x) (stricmp(cl[curarg].c_str(), x) == 0)

    nArgOther = 0;
    // Parse command line
    for (curarg = 0; curarg < cl.size(); curarg++)
    {
        if (ARG_MATCH("--help") || ARG_MATCH("-h") || ARG_MATCH("-?"))
        {
            opt.action = XD_HELP;
            return 0;
        }
        else if (cl[curarg][0] == '-')
        {
            ret = parseOption(cl[curarg], (curarg + 1 >= cl.size())?"":cl[curarg+1], opt);
            curarg += ret-1;
        }
        else
        {
            switch(nArgOther)
            {
            case 0: 
                parseAction(cl[curarg], opt);
                if (opt.action == XD_REM) return 0;
                break;
            case 1: opt.param1 = cl[curarg]; break;
            case 2: opt.param2 = cl[curarg]; break;
            case 3: opt.param3 = cl[curarg]; break;
            case 4: opt.param4 = cl[curarg]; break;
            case 5: opt.param5 = cl[curarg]; break;
            case 6: opt.param6 = cl[curarg]; break;
            case 7: opt.param7 = cl[curarg]; break;
            case 8: opt.param8 = cl[curarg]; break;
            case 9: opt.param9 = cl[curarg]; break;
            default:
                throwError(XD_Exception::XDE_TOO_MANY_ARGUMENTS, "Too many arguments '%'.", cl[curarg].c_str());
            }
            nArgOther++;
        }
    }
    return 0;
}

/// Execute an action from the command line
int executeAction(const struct appCommand & cmd)
{
    int rc;
    map<string, string> vars;

    switch(cmd.action)
    {
    case XD_RECALC:
        rc = recalcXmlFiles(cmd.param1, cmd);
        break;
    case XD_LOAD:
        rc = loadXmlFile(cmd.param1, cmd.param2, cmd);
        break;
    case XD_SAVE:
        rc = saveXmlFile(cmd.param1, cmd.param2, cmd);
        break;
    case XD_CLOSE:
    case XD_DISCARD:
        rc = 0; closeXmlFile(cmd.param1, cmd);
        break;
    case XD_FLUSH:
        rc = 0; flushXmlFiles(cmd);
        break;
    case XD_EXECUTE:
        if (cmd.param2 != "") vars["$1"] = cmd.param2;
        if (cmd.param3 != "") vars["$2"] = cmd.param3;
        if (cmd.param4 != "") vars["$3"] = cmd.param4;
        if (cmd.param5 != "") vars["$4"] = cmd.param5;
        if (cmd.param6 != "") vars["$5"] = cmd.param6;
        if (cmd.param7 != "") vars["$6"] = cmd.param7;
        if (cmd.param8 != "") vars["$7"] = cmd.param8;
        if (cmd.param9 != "") vars["$8"] = cmd.param9;
        rc = executeFile(cmd.param1, vars, cmd);
        break;
    case XD_DIFF:
        rc = diffXmlFiles(cmd.param1, cmd.param2, cmd.param3, cmd);
        break;
    case XD_PRINT:
        cout << cmd.param1 << endl;
        break;
    case XD_DELETE:
        rc = deleteNodes(cmd.param1, BAD_CAST cmd.param2.c_str(), cmd);
        break;
    case XD_DUP:
        rc = duplicateDocument(cmd.param1, cmd.param2, cmd);
        break;
#ifndef WITHOUT_LIBXSLT
    case XD_XSLT:
        // TODO : Parse Parameters
        rc = applyStylesheet(cmd.param1, cmd.param2, cmd.param3, NULL, cmd);
        break;
#endif // WITHOUT_LIBXSLT
    case XD_REM: break;
    case XD_OPTIONS: break;
    case XD_PRINTCONF: 
        printConfiguration(cmd);
        break;
    case XD_HELP:
        usage();
        break;
    default:
        throwError(XD_Exception::XDE_UNKNOWN_COMMAND, "Unknown command.");
        break;
    }
    return rc;
}

/** tokenizeCommand : parse command line
 * @param command command string
 * @return the list of tokens
 */
vector<string> tokenizeCommand(string command)
{
    string::const_iterator iter;
    string buf = "";
    enum eStatus {CL_NONE = 0, CL_IN_ARG, CL_IN_SIMPLE_QUOTE, CL_IN_DOUBLE_QUOTE} status = CL_NONE;
    vector<string> cl;

    #define IS_BLANK(x) ((x == ' ') || (x == '\t') || (x == '\n') || (x == '\r'))

    for(iter = command.begin(); iter != command.end(); iter++)
    {
        switch(status)
        {
        case CL_NONE:
            if (*iter == '"') status = CL_IN_DOUBLE_QUOTE; 
            else if (*iter == '\'') status = CL_IN_SIMPLE_QUOTE;
            else if (!IS_BLANK(*iter)) { status = CL_IN_ARG; buf = *iter; }
            break;
        case CL_IN_ARG:
            if IS_BLANK(*iter)
            {
                cl.push_back(buf);  buf = "";
                status = CL_NONE;
            }
            else buf += *iter;
            break;
        case CL_IN_DOUBLE_QUOTE:
        case CL_IN_SIMPLE_QUOTE:
            if ( ((*iter == '"') && (status == CL_IN_DOUBLE_QUOTE)) ||
                 ((*iter == '\'') && (status == CL_IN_SIMPLE_QUOTE))  )
            {
                cl.push_back(buf);  buf = "";
                status = CL_NONE;
            }
            else buf += *iter;
            break;
        }
    }
    if (buf != "") cl.push_back(buf);  buf = "";
    return cl;
}

/** Replace tokens by other values
 * @param tokens [in, out] the list of tokens
 * @param variables the list of variables name/value
 * @return the number of token replaced, or negative value on error
 */
int replaceTokens(vector<string> & /*[in, out]*/ tokens, map<string, string> variables)
{
    int nb = 0;
    vector<string>::iterator iter;
    for (iter=tokens.begin(); iter != tokens.end(); iter++)
    {
        if (variables.find(*iter) != variables.end())
        {
            *iter = variables[*iter];
            nb++;
        }
    }
    return nb;
}

/** Execute file
 * @param filename the filename of the script to execute
 * @return status code : 
 *        0 no problems
 *      -10 file not found
 */
int executeFile(string scriptFileName, const map<string, string> & variables, const struct globalOptions & gOptions)
{
    int rc = 0;
    struct globalOptions options = gOptions;
    struct appCommand cmd;
    ifstream fin;
    string line;
    char cLine[10240];
    vector<string> tokens;

    verbose(2,gOptions.verboseLevel, "Execute %s ...\n", scriptFileName.c_str());
    fin.open(scriptFileName.c_str());
    while (!fin.eof())
    {
        fin.getline(cLine, sizeof(cLine)); line = cLine;
        if (line == "") continue;
        ((struct globalOptions &)cmd) = options;
        tokens = tokenizeCommand(line);
        replaceTokens(tokens, variables);
        rc = parseCommandLine(tokens, cmd);
        if (cmd.action == XD_OPTIONS)
        {
            options = (struct globalOptions) cmd;
            // printConfiguration(options);
        }
        else
        {
            rc = executeAction(cmd);
        }
    }
    flushXmlFiles(options);
    return rc;
}

/// Print usage
void usage()
{
    cout << "xmldiff - diff two XML files. (c) 2004 - R�mi Peyronnet" << endl
         << "Syntax : xmldiff action [options] <parameters>" << endl
         << endl << "Actions" << endl
         << " - diff <before.xml> <after.xml> <output.xml>" << endl
#ifndef WITHOUT_LIBXSLT
         << " - xslt <style.xsl> <input.xml> <output.xml>" << endl
#endif // WITHOUT_LIBXSLT
         << " - recalc <before.xml> <after.xml>" << endl
         << " - load <filename> <alias>" << endl
         << " - save <filename> <alias>" << endl
         << " - close <alias> / discard <alias> (same as close without saving)" << endl
         << " - flush" << endl
         << " - options" << endl
         << " - print <string>" << endl
         << " - delete <from alias> <xpath expression>" << endl
         << " - dup(licate) <source alias> <dest alias>" << endl
         << " - rem(ark),#,--,;,// <remark>" << endl
         << " - print_configuration" << endl
         << endl << "Global Options : " << endl
         << "  --auto-save yes      : Automatically save modified files" << endl
         << "  --force-clean no     : Force remove of blank nodes and trim spaces" << endl
         << "  --no-blanks yes      : Remove all blank spaces" << endl
         << "  --pretty-print yes   : Output using pretty print writer" << endl
         << "  --optimize no        : Optimize diff algorithm to reduce memory (see doc)" << endl
#ifndef WITHOUT_LIBXSLT
         << "  --use-exslt no       : Allow the use of exslt.org extended functions." << endl
#endif // WITHOUT_LIBXSLT
         << "  --verbose 4          : Verbose level, from 0 (nothing) to 9 (everything)." << endl
         << endl << "Diff Options : " << endl
         << "  --ids '@id,@value'   : Use these item to identify a node" << endl
         << "  --diff-only no       : Do not alter files, just compare." << endl
         << "  --before-values yes  : Add before values in attributes or text nodes" << endl
         << "  --sep |              : Use this as the separator" << endl
         << "  --tag-childs yes     : Tag Added or Removed childs" << endl
            ;
}

/// Dump current configuration
void printConfiguration(const struct globalOptions & opt)
{
    vector<xmlstring>::const_iterator id;
    cout << "Diff Only      : " << ((opt.diffOnly)?"Yes":"No") << endl
         << "Before values  : " << ((opt.beforeValue)?"Yes":"No") 
         << " (separator " << opt.separator.c_str() << ")" << endl
         << "Pretty Print   : " << ((opt.formatPrettyPrint)?"Yes":"No") << endl
         << "No Blanks      : " << ((opt.cleanText)?"Yes":"No") << endl
         << "Force Clean    : " << ((opt.forceClean)?"Yes":"No") << endl
         << "Optimize       : " << ((opt.optimizeMemory)?"Yes":"No") << endl
         << "Auto-Save      : " << ((opt.automaticSave)?"Yes":"No") << endl
         << "Tag Childs     : " << ((opt.tagChildsAddedRemoved)?"Yes":"No") << endl
#ifndef WITHOUT_LIBXSLT
         << "Use EXSLT      : " << ((opt.useEXSLT)?"Yes":"No") << endl
#endif // WITHOUT_LIBXSLT
         << "Verbose Level  : " << opt.verboseLevel << endl
         << "Ids            : ";
    for(id = opt.ids.begin(); id != opt.ids.end(); id++)
    {
        cout << id->c_str() << " ";
    }
    cout << endl << endl;
}

