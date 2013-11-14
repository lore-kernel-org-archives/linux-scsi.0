From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] ddpt, version 0.93 available
Date: Wed, 13 Nov 2013 23:59:25 -0500
Message-ID: <528458AD.8020300@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58329 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3KNE7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 23:59:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Tomas Fasth <tomfa@debian.org>, =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>

ddpt is yet another variant of the venerable Unix dd command
line utility. Some features found in ddpt which are not found
in the current (GNU) dd implementation:

   - extended copy (xcopy) support
   - SCSI protection (DIF) support
   - bandwidth limiting
   - write sparing (i.e. don't write buffer if already same
     as destination)
   - resume (after the copy has been interrupted)
   - trim on output of copy, self trim (pt interface only)
   - send output to a second file (see 'of2=' option)
   - allow access of devices directly via pass-through
     interface, bypassing file system
   - explicit controls over how much data is read into the
     copy buffer and then written to output (separate from
     the logical block sizes of any device involved)


For more information and downloads see:
     http://sg.danny.cz/sg/ddpt.html

Changelog for ddpt-0.93 [20131113] [svn: r242]
   - add xcopy support, new flags: xcopy, cat, dc;
     new options: id_usage=, list_id=, prio=
   - add intio=0|1 ; rework signal handling
   - allow tape device in non-pt mode
   - fix fifo read when bs is large
   - add delay=MS,W_MS for bandwidth limiting
   - add oflag=ignoreew,pad,nofm,nopad for tape
   - add iseek= option, synonym for skip=
   - add oseek= option, synonym for seek=
   - add protect=RDP,WRP option
   - add cdbsz=32 option for READ(32) and WRITE(32)
   - add rarc flag for scsi read cdbs
   - add block flag for pt (non blocking by default)
   - fix overflow on OFILE when input fifo
   - ./configure options:
     - change --enable-no-linux-bsg to --disable-linuxbsg
     - add --disable-scsistrings to reduce utility size
       with non-libsgutils build
   - reduce ddpt.c size by adding ddpt_pt.c
   - win32: fixes for cygwin version 1.7.17 headers
     - translate O_EXCL to no sharing
   - point svn:externals to rev 522 of sg3_utils
   - upgrade automake to version 1.13.3

Changelog for ddpt-0.92 [20110217] [svn: r157]
...

Doug Gilbert
