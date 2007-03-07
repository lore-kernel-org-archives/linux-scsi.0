From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: [Bugme-new] [Bug 8141] New: Adaptec 39320D and long boot
Date: Wed, 7 Mar 2007 12:33:35 -0800
Message-ID: <20070307123335.d7e97db3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965638AbXCGUdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2007 15:33:37 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l27KXZq8032012
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 7 Mar 2007 12:33:36 -0800
Received: from akpm.corp.google.com (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id l27KXZ9p007907
	for <linux-scsi@vger.kernel.org>; Wed, 7 Mar 2007 12:33:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


41-second delay when mounting root fs.

Begin forwarded message:

Date: Wed, 7 Mar 2007 06:15:45 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 8141] New: Adaptec 39320D and long boot


http://bugzilla.kernel.org/show_bug.cgi?id=8141

           Summary: Adaptec 39320D and long boot
    Kernel Version: 2.6.20.1
            Status: NEW
          Severity: normal
             Owner: io_scsi@kernel-bugs.osdl.org
         Submitter: karaluh@tlen.pl


Most recent kernel where this bug did *NOT* occur: none
Distribution: kubuntu

Hardware Environment: 
02:0a.1 SCSI storage controller: Adaptec ASC-39320D (rev 03)

Software Environment:
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
module-init-tools      3.2.2
Linux C Library        > libc.2.4
Dynamic linker (ldd)   2.4
Procps                 3.2.7
udev                   093

Problem Description:
The system boots long with Adaptec 39320D pluged in. It happens in all distro 
kernels i used and in 2.6.20.1 compiled by myself. Some more info here:
https://launchpad.net/ubuntu/+bug/79542

Steps to reproduce:
Plug Adaptec 39320D and boot.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
