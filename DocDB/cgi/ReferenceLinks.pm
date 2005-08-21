
# Copyright 2001-2005 Eric Vaandering, Lynn Garren, Adam Bryant

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

sub ReferenceLink ($) {
  my ($ReferenceID) = @_;
  
  my $ReferenceLink = "";
  my $ReferenceText = "";
  if ($ReferenceID) {
    my $JournalID = $RevisionReferences{$ReferenceID}{JournalID};
    my $Volume    = $RevisionReferences{$ReferenceID}{Volume};
    my $Page      = $RevisionReferences{$ReferenceID}{Page};
    my $Acronym   = $Journals{$JournalID}{Acronym};
    
    if ($Acronym eq "PRL" || $Acronym eq "PRD")    {
      ($ReferenceLink,$ReferenceText) = &APSLink($Acronym,$Volume,$Page);
    }
    if ($Acronym eq "PLB" || $Acronym eq "NIMA")    {
      ($ReferenceLink,$ReferenceText) = &NPELink($Acronym,$Volume,$Page);
    }
    if ($Acronym eq "physics" || $Acronym eq "hep-ex" || $Acronym eq "hep-ph" || $Acronym eq "hep-th") {
      ($ReferenceLink,$ReferenceText) = &ArxivLink($Acronym,$Volume,$Page);
    }

    if (!$ReferenceLink && prototype ProjectReferenceLink) { # Only if it exists
      ProjectReferenceLink($Acronym,$Volume,$Page,$ReferenceID);
    }
  }
  return $ReferenceLink,$ReferenceText;
}

sub APSLink ($$$) {

#http://link.aps.org/abstract/PRL/V88/E161801
  my ($Acronym,$Volume,$Page) = @_;

#  my %PubNumber       = ();
#     $PubNumber{PLB}  = "03702693";
#     $PubNumber{NIMA} = "01689002";

  ($Page) = split /\D/,$Page; # Remove any trailing non-digits 
  $Volume =~ s/\D//;    # Remove any non-digits 

  my $ReferenceLink = "http://link.aps.org/abstract/$Acronym/V$Volume/E$Page/";
  my $ReferenceText = "";

  return $ReferenceLink,$ReferenceText;

}

sub NPELink ($$$) {
  my ($Acronym,$Volume,$Page) = @_;

  my %PubNumber       = ();
     $PubNumber{PLB}  = "03702693";
     $PubNumber{NIMA} = "01689002";

  ($Page) = split /\D/,$Page; # Remove any trailing non-digits 
  $Volume =~ s/\D//;    # Remove any non-digits 

  my $ReferenceLink = "http://www.elsevier.com/IVP/$PubNumber{$Acronym}/$Volume/$Page/";
  my $ReferenceText = "";

  return $ReferenceLink,$ReferenceText;
}

sub ArxivLink ($$$) {
  my ($Acronym,$Volume,$Page) = @_;

  my $ReferenceLink = "http://www.arxiv.org/abs/$Acronym/$Page";
  my $ReferenceText = "$Acronym/$Page";

  return $ReferenceLink,$ReferenceText;
}

1;
