From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [0/5] - description
Date: Tue, 9 Mar 2004 15:22:11 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309042211.GA12249@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:40644 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S261500AbUCIEWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 23:22:15 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Here's a few patches for the dc395x driver that can be applied.
Nothing major or very important. Some formatting cleanups requested
by Christoph, some character set changes requested by David Eger,
some cleanup/documenting of the sg list handling and a load of other
formatting and debugging cleanups.

(I've now moved my card to a sparc64 machine, so the next lot of
patches will hopefully make it work on 64-bit & big-endian machines.)


[1/5] 20030929-#13-formatting-cleanup.patch
  Formatting cleanups.
  - Remove lots of comments that were out-of-date, wrong, or now
    described things that had been simplified that much that the
    comments were no longer needed.
  - Move the "static" definition from a line before functions onto the
    same line as the function itself.
  - Remove "return;" from the end of void functions.
  - Remove braces from around single instructions.
  - Merge the declaration and assignment to variables in places where
    the followed each other.
  - Remove braces from around single statement that obviously didn't
    need them.
  - Remove unused code and variables.
  - Fix debug statement in disconnect to not deref potentially null
    ptr.
  - Change a lot of short comments that take up three lines down to one
    line.

[2/5] 20040216-#14-sg-cleanup1.patch
  Cleanup a lot of the sg list handling to make it easier to follow in
  preparation for making this work on sparc64 (big-endian & 64bit).

[3/5] 20040307-#16-removedebugging.patch
  Remove the special versions of kmalloc and kfree and remove the trace
  related stuff from the code. None of this is really needed and it is
  not really a nice implementation. This also removes all non 7-bit
  clean characters to help with David Eger's work to remove and/or
  convert them all to UTF8.

[4/5] 20040308-#17-debuggingcleanup.patch
  Clean up debugging statements. Work on making output consistent - use
  the same format each time the same bit of information is output and
  output the same bits of information in the same order each time it's
  output. Update a lot of the actual messages to include useful
  information and to explain better what some things are. Remove some
  old comments and commented out code. Remove some of the debugging
  states. Find few instance of spaces that should have been tabs and
  trailing white space and remove them.

[5/5] 20040308-#18-versionupdate.patch
  Move version information from .h to .c so that it's more likely to
  get updated as changes are made (the .h file is rarely modified).
  Update the version from 2.04 to 2.05

-- 
 Jamie Lenehan <lenehan@twibble.org>
