#        Name: UntaintListOfWords.pm
# Description: Allows a list of (null separated) words
#
#      Author: Eric Vaandering (ewv@fnal.gov)
#    Modified: Eric Vaandering (ewv@fnal.gov)

# Copyright 2001-2013 Eric Vaandering, Lynn Garren, Adam Bryant

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
#    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

package CGI::Untaint::listofwords;

$VERSION = '1.00';

use strict;
use base 'CGI::Untaint::object';

sub _untaint_re { qr/^((\w+)(\000)*)+$/ }

sub is_valid {
  my $self = shift;
  my $RawValue = $self->value;
  my @Values = split /\0/,$RawValue;
  my $ArrRef = \@Values;

  $self->value($ArrRef);
}

1;
