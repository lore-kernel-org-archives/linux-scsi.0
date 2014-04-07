From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] ddpt, version 0.94 available
Date: Mon, 07 Apr 2014 15:27:33 -0400
Message-ID: <5342FC25.4090208@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60310 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbaDGT1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2014 15:27:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Tomas Fasth <tomfa@debian.org>, =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Hannes Reinecke <hare@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>

ddpt is yet another variant of the venerable Unix dd command
line utility. This version adds application side support for
a second offloaded copy mechanism defined by T10 around two
years ago and already on the market under the name ODX.

For more information and downloads see:
     http://sg.danny.cz/sg/ddpt.html
     http://sg.danny.cz/sg/ddpt_xcopy_odx.html

Changelog for ddpt-0.94 [20140407] [svn: r277]
   - xcopy: change default to send xcopy command to dst
     - add XCOPY_TO_SRC and XCOPY_TO_DST environment
       variables to guide where to send xcopy command
   - odx: add new offloaded copy technique, also known
     as "xcopy v2, lite", that exposes ROD Tokens
     - ddpt supports 4 odx variants: full copy, zero
       output blocks, read to tokens and write from
       tokens. Latter two facilitate network copies
     - add scatter-gather list capability to seek=,
       skip= to read from command line, file or stdin
   - ddptctl: add odx helper utility
     - can issue individual PT, WUT, RRTI, Report All
       Rod Tokens, and Copy Operation Abort commands
     - can decode T10 defined info in Rod Token
   - improve CL handling of short options (e.g. '-vv')
   - point svn:externals to rev 563 of sg3_utils
   - configure: add --disable-libsgutils option so
     build bypasses that library if present

Changelog for ddpt-0.93 [20131113] [svn: r242]
...

Doug Gilbert
