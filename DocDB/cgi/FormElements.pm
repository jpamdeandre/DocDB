#
#        Name: FormElements.pm
# Description: Various routines which supply input forms for document 
#              addition, etc. This file is deprecated. Routines are 
#              being moved out into the various *HTML.pm files.
#
#      Author: Eric Vaandering (ewv@fnal.gov)
#    Modified: 
#

# Copyright 2001-2004 Eric Vaandering, Lynn Garren, Adam Bryant

#    This file is part of DocDB.

#    DocDB is free software; you can redistribute it and/or modify
#    it under the terms of version 2 of the GNU General Public License 
#    as published by the Free Software Foundation.

#    DocDB is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with DocDB; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

require "TopicHTML.pm";

sub DaysPulldown {
  my @Days = (1,2,3,5,7,10,14,20,30,45,60,90,120,180 );
  print $query -> popup_menu (-name    => 'days', -values   => \@Days,
                              -default => $Days,  -onChange => "submit()");
}

sub DateTimePullDown {
  my ($sec,$min,$hour,$day,$mon,$year) = localtime(time);
  $year += 1900;
  $min = (int (($min+3)/5))*5; # Nearest five minutes
  
  my @days = ();
  for ($i = 1; $i<=31; ++$i) {
    push @days,$i;
  }  

  my @months = ("Jan","Feb","Mar","Apr","May","Jun",
             "Jul","Aug","Sep","Oct","Nov","Dec");

  my @years = ();
  for ($i = $FirstYear; $i<=$year; ++$i) { # $FirstYear - current year
    push @years,$i;
  }  

  my @hours = ();
  for ($i = 0; $i<24; ++$i) {
    push @hours,$i;
  }  

  my @minutes = ();
  for ($i = 0; $i<=55; $i=$i+5) {
    push @minutes,(sprintf "%2.2d",$i);
  }  
  
  print "<b><a ";
  &HelpLink("overdate");
  print "Date & Time:</a></b><br> \n";
  print $query -> popup_menu (-name => 'overday',-values => \@days, -default => $day);
  print $query -> popup_menu (-name => 'overmonth',-values => \@months, -default => $months[$mon]);
  print $query -> popup_menu (-name => 'overyear',-values => \@years, -default => $year);
  print "<br>\n";
  print $query -> popup_menu (-name => 'overhour',-values => \@hours, -default => $hour);
  print "<b> : </b>\n";
  print $query -> popup_menu (-name => 'overmin',-values => \@minutes, -default => $min);
}

sub StartDatePullDown {
  my ($sec,$min,$hour,$day,$mon,$year);
  
  if ($DefaultStartDate) {
    ($year,$mon,$day) = split /-/,$DefaultStartDate;
    $day  = int($day);
    $mon  = int($mon);
    $year = int($year);
    --$mon;
  } else {
    ($sec,$min,$hour,$day,$mon,$year) = localtime(time);
    $year += 1900;
  }
  
  my @days = ();
  for ($i = 1; $i<=31; ++$i) {
    push @days,$i;
  }  

  my @months = ("Jan","Feb","Mar","Apr","May","Jun",
             "Jul","Aug","Sep","Oct","Nov","Dec");

  my @years = ();
  for ($i = $FirstYear; $i<=$year+2; ++$i) { # $FirstYear - current year
    push @years,$i;
  }  

  print "<b><a ";
  &HelpLink("startdate");
  print "Start Date:</a></b><br> \n";
  print $query -> popup_menu (-name => 'startday',-values => \@days, -default => $day);
  print $query -> popup_menu (-name => 'startmonth',-values => \@months, -default => $months[$mon]);
  print $query -> popup_menu (-name => 'startyear',-values => \@years, -default => $year);
}

sub EndDatePullDown {
  my ($sec,$min,$hour,$day,$mon,$year);
  
  if ($DefaultStartDate) {
    ($year,$mon,$day) = split /-/,$DefaultEndDate;
    $day  = int($day);
    $mon  = int($mon);
    $year = int($year);
    --$mon;
  } else {
    ($sec,$min,$hour,$day,$mon,$year) = localtime(time);
    $year += 1900;
  }
  
  my @days = ();
  for ($i = 1; $i<=31; ++$i) {
    push @days,$i;
  }  

  my @months = ("Jan","Feb","Mar","Apr","May","Jun",
             "Jul","Aug","Sep","Oct","Nov","Dec");

  my @years = ();
  for ($i = $FirstYear; $i<=$year+2; ++$i) { # $FirstYear - current year
    push @years,$i;
  }  

  print "<b><a ";
  &HelpLink("enddate");
  print "End Date:</a></b><br> \n";
  print $query -> popup_menu (-name => 'endday',-values => \@days, -default => $day);
  print $query -> popup_menu (-name => 'endmonth',-values => \@months, -default => $months[$mon]);
  print $query -> popup_menu (-name => 'endyear',-values => \@years, -default => $year);
}

sub PubInfoBox {
  print "<b><a ";
  &HelpLink("pubinfo");
  print "Other publication information:</a></b><br> \n";
  print $query -> textarea (-name => 'pubinfo', -default => $PubInfoDefault,
                            -columns => 60, -rows => 3);
};

sub RequesterSelect { # Scrolling selectable list for requesting author
  my ($Quiet) = @_;
  
  require "AuthorSQL.pm";
  unless (keys %Author) {
    &GetAuthors;
  }
  
  my @AuthorIDs = sort byLastName keys %Authors;
  my %AuthorLabels = ();
  my @ActiveIDs = ();
  foreach my $ID (@AuthorIDs) {
    if ($Authors{$ID}{ACTIVE}) {
      $AuthorLabels{$ID} = $Authors{$ID}{Formal};
      push @ActiveIDs,$ID; 
    } 
  }
  unless ($Quiet) {  
    print "<b><a ";
    &HelpLink("requester");
    print "Requester:</a></b><br> \n";
  }  
  print $query -> scrolling_list(-name => "requester", -values => \@ActiveIDs, 
                                 -size => 10, -labels => \%AuthorLabels,                      
                                 -default => $RequesterDefault);
};

sub AuthorSelect { # Scrolling selectable list for authors
                   # FIXME: Use AuthorMultipleScroll
  require "AuthorSQL.pm";
  unless (keys %Author) {
    &GetAuthors;
  }
  
  my @AuthorIDs = sort byLastName keys %Authors;
  my %AuthorLabels = ();
  my @ActiveIDs = ();
  foreach my $ID (@AuthorIDs) {
    if ($Authors{$ID}{ACTIVE}) {
      $AuthorLabels{$ID} = $Authors{$ID}{Formal};
      push @ActiveIDs,$ID; 
    } 
  }  
  print "<b><a ";
  &HelpLink("authors");
  print "Authors:</a></b><br> \n";
  print $query -> scrolling_list(-name => "authors", -values => \@ActiveIDs, 
                                 -labels => \%AuthorLabels,
                                 -size => 10, -multiple => 'true',
                                 -default => \@AuthorDefaults);
};

sub TopicSelect { # Scrolling selectable list for topics
  my @TopicIDs = sort byTopic keys %MinorTopics;
  my %TopicLabels = ();
  foreach my $ID (@TopicIDs) {
    $TopicLabels{$ID} = $MinorTopics{$MinorTopicID}{Full};
  }
  print "<b><a ";
  &HelpLink("topics");
  print "Topics:</a></b><br> \n";
  print $query -> scrolling_list(-name => "topics", -values => \@TopicIDs, 
                                 -labels => \%TopicLabels,
                                 -size => 10, -multiple => 'true',
                                 -default => \@TopicDefaults);
};

sub TopicSelectLong { # Scrolling selectable list for topics, all info
  my @TopicIDs = sort byTopic keys %MinorTopics;
  my %TopicLabels = ();
  foreach my $ID (@TopicIDs) {
    $TopicLabels{$ID} = $MinorTopics{$ID}{Full}." [$MinorTopics{$ID}{LONG}]"; 
  }  
  print "<b><a ";
  &HelpLink("topics");
  print "Topics:</a></b> (Long descriptions in brackets)<br> \n";
  print $query -> scrolling_list(-name => "topics", -values => \@TopicIDs, 
                                 -labels => \%TopicLabels,
                                 -size => 10, 
                                 -default => \@TopicDefaults);
};

sub MultiTopicSelect { # Multiple scrolling selectable lists for topics
  require "TopicSQL.pm";
  
  &SpecialMajorTopics;

  my $NCols = 4;
  my @MajorIDs = sort byMajorTopic keys %MajorTopics;
  my @MinorIDs = keys %MinorTopics;

  print "<table cellpadding=5>\n";
  print "<tr><td colspan=$NCols align=center>\n";
  print "<b><a ";
  &HelpLink("topics");
  print "Topics:</a></b><br> \n";
  my $Col = 0;
  foreach $MajorID (@MajorIDs) {
    unless ($Col % $NCols) {
      print "<tr valign=top>\n";
    }
    print "<td><b>$MajorTopics{$MajorID}{SHORT}</b><br>\n";
    ++$Col;
    my @MatchMinorIDs = ();
    my %MatchLabels = ();
    foreach my $MinorID (@MinorIDs) {
      if ($MinorTopics{$MinorID}{MAJOR} == $MajorID) {
        push @MatchMinorIDs,$MinorID;
        $MatchLabels{$MinorID} = $MinorTopics{$MinorID}{SHORT};
      }  
    }
    @MatchMinorIDs = sort byTopic @MatchMinorIDs;

    print $query -> scrolling_list(-name => "topics", 
             -values => \@MatchMinorIDs, -labels => \%MatchLabels,
             -size => 8, -multiple => 'true', -default => \@TopicDefaults);
    print "</td>\n";
  }  
  print "</table>\n";
};

sub MajorTopicSelect (;$) { # Scrolling selectable list for major topics
  my ($Mode) = @_; 
  
  print "<b><a ";
  &HelpLink("majortopics");
  print "Major Topics:</a></b><br> \n";
  my @MajorIDs = keys %MajorTopics;
  my %MajorLabels = ();
  foreach my $ID (@MajorIDs) {
    if ($Mode eq "full") {
      $MajorLabels{$ID} = $MajorTopics{$ID}{Full};
    } else {  
      $MajorLabels{$ID} = $MajorTopics{$ID}{SHORT};
    }  
  }  
  print $query -> scrolling_list(-name => "majortopic", -values => \@MajorIDs, 
                                 -labels => \%MajorLabels,  -size => 10);
};

sub InstitutionSelect ($) { # Scrolling selectable list for institutions
  require "Sorts.pm";
  my ($Mode) = @_;
  print "<b><a ";
  &HelpLink("institution");
  print "Institution:</a></b>";
  if ($Mode eq "full") {print " (Long descriptions in brackets)";}
  print "<br> \n";
  my @InstIDs = sort byInstitution keys %Institutions;
  my %InstLabels = ();
  foreach my $ID (@InstIDs) {
    if ($Mode eq "full") {
      $InstLabels{$ID} = $Institutions{$ID}{SHORT}." [".$Institutions{$ID}{LONG}."]";
    } else {
      $InstLabels{$ID} = $Institutions{$ID}{SHORT};
    }
  }  
  print $query -> scrolling_list(-name => "inst", -values => \@InstIDs,
                                 -labels => \%InstLabels,  -size => 10);
};

sub NameEntryBox {
  print "<table cellpadding=5><tr valign=top>\n";
  print "<td>\n";
  print "<b><a ";
  &HelpLink("authorentry");
  print "First Name:</a></b><br> \n";
  print $query -> textfield (-name => 'first', 
                             -size => 20, -maxlength => 32);
  print "</td></tr>\n";
  print "<tr><td>\n";
  print "<b><a ";
  &HelpLink("authorentry");
  print "Initials:</a></b><br> \n";
  print $query -> textfield (-name => 'middle', 
                             -size => 10, -maxlength => 16);
  print "</td></tr>\n";
  print "<tr><td>\n";
  print "<b><a ";
  &HelpLink("authorentry");
  print "Last Name:</a></b><br> \n";
  print $query -> textfield (-name => 'lastname', 
                             -size => 20, -maxlength => 32);
  print "</td>\n";
  print "</tr></table>\n";
}

sub UpdateButton {
  my ($DocumentID) = @_;

#  unless (&CanModify) {return;}

  $query -> param('mode','update'); 
  $query -> param('docid',$DocumentID);
  
  print $query -> startform('POST',$DocumentAddForm);
  print $query -> hidden(-name => 'mode',  -default => 'update');
  print $query -> hidden(-name => 'docid', -default => $DocumentID);
  print $query -> submit (-value => "Update Document");
  print $query -> endform;
}

sub UpdateDBButton {
  my ($DocumentID,$Version) = @_;
  
#  unless (&CanModify) {return;}

  $query -> param('mode',   'updatedb');
  $query -> param('docid',  $DocumentID);
  $query -> param('version',$Version);
  
  print $query -> startform('POST',$DocumentAddForm);
  print $query -> hidden(-name =>    'mode', -default => 'updatedb');
  print $query -> hidden(-name =>   'docid', -default => $DocumentID);
  print $query -> hidden(-name => 'version', -default => $Version);
  print $query -> submit (-value => "Update DB Info");
  print $query -> endform;
}

sub AddFilesButton {
  my ($DocumentID,$Version) = @_;

#  unless (&CanModify) {return;}

  $query -> param('docid',$DocumentID);
  $query -> param('version',$Version);
  
  print $query -> startform('POST',$AddFilesForm);
  print $query -> hidden(-name => 'docid',   -default => $DocumentID);
  print $query -> hidden(-name => 'version', -default => $Version);
  print $query -> submit (-value => "Add Files to Document");
  print $query -> endform;
}

sub AuthorManual { # FIXME: Special case of AuthorTextEntry
  $AuthorManDefault = "";

  foreach $AuthorID (@AuthorDefaults) {
    $AuthorManDefault .= "$Authors{$AuthorID}{FULLNAME}\n" ;
  }  
  print "<b><a ";
  &HelpLink("authormanual");
  print "Authors:</a></b><br> \n";
  print $query -> textarea (-name    => 'authormanual', 
                            -default => $AuthorManDefault,
                            -columns => 20, -rows    => 8);
};

sub ReferenceForm {
  require "MiscSQL.pm";
  
  &GetJournals;

  my @JournalIDs = keys %Journals;
  my %JournalLabels = ();
  foreach my $ID (@JournalIDs) {
    $JournalLabels{$ID} = $Journals{$ID}{Acronym};
  }
  @JournalIDs = sort @JournalIDs;  #FIXME Sort by acronym
  unshift @JournalIDs,0; $JournalLabels{0} = "----"; # Null Journal
  print "<b><a ";
  &HelpLink("reference");
  print "References:</a></b><br> \n";
  
  my @ReferenceIDs = (@ReferenceDefaults,0);
  
  print "<table cellpadding=3>\n";
  foreach my $ReferenceID (@ReferenceIDs) { 
    print "<tr>\n";
    my $JournalDefault = $RevisionReferences{$ReferenceID}{JournalID};
    my $VolumeDefault  = $RevisionReferences{$ReferenceID}{Volume}   ;
    my $PageDefault    = $RevisionReferences{$ReferenceID}{Page}     ;
    print "<td><b>Journal: </b>\n";
    print $query -> popup_menu(-name => "journal", -values => \@JournalIDs, 
                                   -labels => \%JournalLabels,
                                   -default => $JournalDefault);

    print "<td><b>Volume:</b> \n";
    print $query -> textfield (-name => 'volume', 
                               -size => 8, -maxlength => 8, 
                               -default => $VolumeDefault);

    print "<td><b>Page:</b> \n";
    print $query -> textfield (-name => 'page', 
                               -size => 8, -maxlength => 16, 
                               -default => $PageDefault);
    print "</tr>\n";                           
  }
  print "</table>\n";
}

1;
