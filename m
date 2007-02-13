From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work with
 LSI MegaRAID i4 since release 2.00.4
Date: Tue, 13 Feb 2007 09:29:20 -0800
Message-ID: <20070213092920.f0bafea0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45230 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXBMR3i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Feb 2007 12:29:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, rico@ricospirit.net



Begin forwarded message:

Date: Tue, 13 Feb 2007 04:38:49 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work with LSI MegaRAID i4 since release 2.00.4


http://bugzilla.kernel.org/show_bug.cgi?id=7999

           Summary: MegaRAID Legacy doesn't work with LSI MegaRAID i4 since
                    release 2.00.4
    Kernel Version: 2.6.20
            Status: NEW
          Severity: blocking
             Owner: scsi_drivers-other@kernel-bugs.osdl.org
         Submitter: rico@ricospirit.net


Most recent kernel where this bug did *NOT* occur:2.6.14 ?
Distribution:Debian Sarge
Hardware Environment: Asus A7V266 M/B, Adaptec AHA-2940UW, LSI MegaRAID 511 i4
Software Environment:
Problem Description: My MegaRAID i4 adapter, witch works well on linux 2.6.11.6
kernel, doesn't work anymore with newer kernels whereas I use the same config
file (updated by 'make oldconfig') I compared megaraid.c from 2.6.11 and 2.6.20
and I noticed megaraid version goes from 2.00.3 to 2.00.4, so I guess the
problem is here ?

Steps to reproduce: simply compile a kernel >= 2.6.15 with megaraid legacy support !

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
