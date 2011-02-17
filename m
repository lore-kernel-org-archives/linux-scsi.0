From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] ddpt, version 0.92 available
Date: Thu, 17 Feb 2011 15:51:34 -0500
Message-ID: <4D5D8A56.4070502@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33944 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab1BQUvl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2011 15:51:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Tomas Fasth <tomfa@debian.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>

ddpt is yet another variant of the venerable Unix
dd command line utility. Some features found in
ddpt which are not found in the current (GNU) dd
implementation:

   - sparse writing (i.e. don't write buffer if all zeros)
   - write sparing (i.e. don't write buffer if already same
     as destination)
   - resume (after the copy has been interrupted)
   - trim on output of copy, self trim (pt interface only)
   - send output to a second file (see 'of2=' option)
   - access devices directly via pass-through interface,
     bypassing file system
   - accept numeric command line arguments in hexadecimal
   - explicit controls over how much data is read into the
     copy buffer and then written to output (separate from
     the logical block sizes of any device involved)

The initial public release was 0.91 in September 2010.
This version (0.92) has a few new features, many bug fixes
and more informative output. For more information and
downloads see:
     http://sg.danny.cz/sg/ddpt.html


Changelog for ddpt-0.92 [20110217] [svn: r157]
   - when pt used on block device and discrepancy between size
     of block device and read capacity size, require force flag
   - add coe support for input block devices and regular files
   - support conv=fdatasync, conv=fsync, oflag=fdatasync and
     oflag=fsync; called at end of copy
   - allow partial writes of trailing bytes when output is
     regular file or fifo (stdout), ignore if block or pt device
   - fix stdin, stdout and fifo handling problems
   - if iflag=sparse and of=/dev/null (or not given) warn but
     set oflag=sparse and continue
   - treat unrecovered errors as partial (as dd does)
   - win32: add '--wscan' option to scan for devices and volumes
     - select SPT direct pt interface
   - add estimate of remaining time in progress signal handler
   - accept but ignore cbs= option
   - error reporting clean up
   - add AM_MAINTAINER_MODE to configure.ac to lessen build issues

Changelog for ddpt-0.91 [20100920] [svn: r121]
....

Doug Gilbert
