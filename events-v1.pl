#!/usr/bin/perl

use JSON;
use JSON::Parse 'json_file_to_perl';
use Data::Dumper;
use Switch;

my $file = $ARGV[0];
my $hash_ref = json_file_to_perl ($file);

my $css = qq!
!;

my $include = qq!



	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.8/css/jquery.dataTables.min.css">

	
	<script type="text/javascript" language="javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.8/js/jquery.dataTables.min.js"></script>
	<script type="text/javascript" class="init">

\$(document).ready(function() {


    // Setup - add a text input to each footer cell
    \$('#example tfoot th').each( function () {
        var title = \$('#example thead th').eq( \$(this).index() ).text();
        \$(this).html( '<input type="text" placeholder="Search '+title+'" />' );
    } );
 
    // DataTable
    var table = \$('#example').DataTable( {
		"stateSave": true,
		"scrollY":        "350px",
		"scrollCollapse": true
        });
 
    // Apply the search
    table.columns().every( function () {
        var that = this;
 
        \$( 'input', this.footer() ).on( 'keyup change', function () {
            that
                .search( this.value )
                .draw();
        } );
        
    } );
    
} );




	</script>
	<style>
	body { background: #dddddd; color: #000000; }
	tfoot input {
        width: 100%;
        padding: 3px;
        box-sizing: border-box;
    }
    </style>

!;

# print the html
print qq!<html>\n!;
print qq!<head>\n!;
print qq!$include!;
print qq!</head>\n!;
print qq!<body>\n!;

print qq!<table id="example" class="display" cellspacing="0" width="100%">\n!;

print qq!<thead>\n!;
print qq!<tr>\n!;
print qq!<th>Agent</th>\n!;
print qq!<th>Node</th>\n!;
print qq!<th>Severity</th>\n!;
print qq!<th>Account ID</th>\n!;
print qq!<th>Account Name</th>\n!;
print qq!<th>Event Summary</th>\n!;
print qq!</tr>\n!;
print qq!</thead>\n!;

print qq!<tfoot>\n!;
print qq!<tr>\n!;
print qq!<th>Agent</th>\n!;
print qq!<th>Node</th>\n!;
print qq!<th>Severity</th>\n!;
print qq!<th>Account ID</th>\n!;
print qq!<th>Account Name</th>\n!;
print qq!<th>Event Summary</th>\n!;
print qq!</tr>\n!;
print qq!</tfoot>\n!;

print qq!<tbody>\n!;
my $colspan = 4;
my $x = 0;
my $row_color = '#ededed;';
my %sev = ( 25 => 'Synthetic NoAck', 15 => 'Synthetic Ack', 5 => 'Critical', 4 => 'Warning', 3 => 'Notice', 2 => 'Information', 1 => 'Debug', 0 => 'Clear' );

my %fields = ( "FirstOccurrence", 

foreach my $obj (@{$hash_ref->{rowset}->{rows}}) { 
	
	next unless ( $obj->{Agent} );
	
	my $severity = $obj->{Severity};
	switch ($severity) {
		case 5 { $row_color = 'red' }
		case 4 { $row_color = 'orange' }
		case 3 { $row_color = 'yellow' }
		case 2 { $row_color = 'blue' }
		case 25 { $row_color = '#ffffff' }
		case 15 { $row_color = '#00ffff' }
		else { $row_color = 'green' }
	}
	
	# begin event fields row
	print qq!<tr>\n!;
	
	print qq!<td style='background:$row_color;'>\n!;
	print qq!$obj->{Agent} \n!;
	print qq!</td>\n!;
	
	print qq!<td style='background:$row_color;'>\n!;
	print qq!$obj->{Node} \n!;
	print qq!</td>\n!;
	
	print qq!<td style='background:$row_color; width:150px;'>\n!;
	print qq!$obj->{Severity} ( $sev{$severity} ) \n!;
	print qq!</td>\n!;
		
	print qq!<td style='background:$row_color;'>\n!;
	print qq!$obj->{aka_account_id} \n!;
	print qq!</td>\n!;
	
		print qq!<td style='background:$row_color;'>\n!;
	print qq!$obj->{aka_account_name} \n!;
	print qq!</td>\n!;
	
	print qq!<td style='background:$row_color;'>\n!;
	print qq!$obj->{Summary} \n!;
	print qq!</td>\n!;

	print qq!</tr>\n!;
}
print qq!</tbody>\n!;

print qq!</table>\n!;

print qq!</body>\n!;
print qq!</html>\n!;
