module yacc
import os
// yacc and bison header include.
#include "*.tab.h"

fn C.yyparse() int

struct YaccConfig{
	file_prefix:	''	  // -b
	define_name:	''	  // -d
	prefix_name:	''	  // -p
	debug_mode: 	false // -t
	report: 		false // -v
	optimize:		false // -l
	parser_only:	false // -n
 }

struct BisonConfig {
	file_prefix:	''	  // -b
	define_name:	''	  // -d
	output_name: 	''	  // -o
	prefix_name:	''	  // -p
	debug_mode: 	false // -t
	report: 		false // -v
	optimize:		false // -l
	parser_only:	false // -n
}

struct LexConfig {
	multibyte_euc:		false // -e
	multibyte_unicode:	false // -w
	generating_stream: 	false // -t
	table_archive:		false // -n
	report:				false // -v
}

struct FlexConfig{
	output_name: 			''    // -o
	prefix_name:			''	  // -P
	generating_backtrack:	false // -b
	debug_mode: 			false // -d
	error_check: 			false // -p
	scanner_panic:			false // -s
	generating_stream:		false // -t
	full_table:				false // -f
	pascal_mode:			false // -i
	report:					false // -v 
	intractive:				false // -I
	line_error_remove:		false // -L
	fast_table:				false // -F
	no_warning:				false // -w
	meta_equal_class:		false // -Cm
	unicode_mode:			false // -Ca
	read_call:				false // -Cr
	equal_class:			false // -Ce
	table_archive_only:		false // -C
	trace_mode:				false // -T
	input_8bit:				false // -8
}

fn yacc_config(y YaccConfig) string{
	mut temp := ''
	if y.file_prefix != ''{
		temp += '-b $y.fileprefix'
	}
	if y.define_name != ''{
		temp += '-d $y.define_name'
	}
	if y.prefix_name != ''{
		temp += '-p $y.prefix_name'
	}
	if y.debug_mode {
		temp += '-t'
	}
	if y.report {
		temp += '-v'
	}
	if y.optimize {
		temp += '-l'
	}
	if y.parser_only {
		temp += '-n'
	}
	return temp
}

fn bison_config(b BisonConfig) string{
	mut temp := ''
	if b.file_prefix != ''{
		temp += '-b $b.fileprefix'
	}
	if b.define_name != ''{
		temp += '-d $b.define_name'
	}
	if b.output_name != ''{
		temp += '-o $b.output_name'
	}
	if b.prefix_name != ''{
		temp += '-p $b.prefix_name'
	}
	if b.debug_mode {
		temp += '-t'
	}
	if b.report {
		temp += '-v'
	}
	if b.optimize {
		temp += '-l'
	}
	if b.parser_only {
		temp += '-n'
	}
	return temp
}

fn lex_config(l LexConfig) ?string{
	mut temp := ''
	if l.multibyte_euc {
		if !l.multibyte_unicode{
			temp += '-e'
		} else {
			return error('Character Code Error')
		}
	}
	if l.multibyte_unicode{
		if !l.multibyte_euc{
			temp += '-w'
		} else {
			return error('Charater Code Error')
		}
	}
	if l.generating_stream{
		temp += '-t'
	}
	if l.table_archive {
		temp += '-n'
	}
	if l.report {
		temp += '-v'
	}
	return temp
}

fn flex_config(f FlexConfig) string{
	mut temp := ''
	if f.output_name != ''{
		temp += '-o $f.output_name'
	}
	if f.prefix_name != ''{
		temp += '-P $f.prefix_name'
	}
	if f in [.fast_table,.full_table,.equal_class,.meta_equal_class,.read_call,.unicode_mode,.table_archive_only]{
		mut temp2 := '-C'
		if !table_archive_only{
			if .fast_table{
				temp2 += 'f'
			}
			if .full_table{
				temp2 += 'F'
			}
			if .equal_class{
				temp2 += 'e'
			}
			if .meta_equal_class{
				temp2 += 'm'
			}
			if .read_call{
				temp2 += 'r'
			}
			if .unicode_mode{
				temp2 += 'a'
			}
		}
		temp += temp2
	}
	if f.scanner_panic{
		temp += '-s'
	}
	if generating_stream{
		temp += '-t'
	}
	if f.pascal_mode{
		temp += '-i'
	}
	if f.intractive{
		temp += '-I'
	}
	if f.line_error_remove{
		temp += '-L'
	}
	if f.input_8bit{
		temp += '-8'
	}
	if f.no_warning{
		temp += '-w'
	}
	if f.trace_mode{
		temp += '-T'
	}
	if f.debug_mode{
		temp += '-d'
	}
	if f.generating_backtrack {
		temp += '-b'
	}
	if f.debug_mode {
		temp += '-d'
	}
	if f.error_check{
		temp += '-p'
	}
	if f.report {
		temp += '-v'
	}
	return temp
}

// lanuch yacc compile to C.
pub fn yacc_compile(file_path string,config YaccConfig) {
	args := yacc_config(config)
	bison := os.system('bison -y $file_path $args')
	yacc := if bison == -1 {
		system('yacc $file_path $args') 
	} else {
		0	
	}

	if yacc == -1 {
		eprintln('Please Install yacc/bison.')
	}
}

// lanuch bison compile to C.
pub fn bison_compile(file string, config BisonConfig) {
	args := bison_config(config)
    bison := os.system('bison $file $args')
	if bison == -1 {
		eprintln('Please Install bison')
	}
}

// lanuch lex compile to C.
pub fn lex_compile(file string, config LexConfig) {
	args := lex_config(config)
	lex := os.system('lex $file $args')
	if lex == -1 {
		eprintln('Please Install lex')
	}
}

// lanuch flex compile to C.
pub fn flex_compile(file string){
	args := flex_config()
	flex := os.system('flex $file') 
	if flex == -1 {
		eprintln('Please Install flex')
	}
}

// wrapping yacc.
pub fn yyparse(){
	&C.yyparse()
}
