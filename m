From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 7616] New: new kernel 2.6.19 causes aic7xxx
 driver to not work with tape drive
Date: Fri, 1 Dec 2006 20:39:07 -0800
Message-ID: <20061201203907.880ffee0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60113 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1162780AbWLBEjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2006 23:39:09 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kB24d8jQ011698
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Dec 2006 20:39:08 -0800
Received: from box (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id kB24d7ub007484
	for <linux-scsi@vger.kernel.org>; Fri, 1 Dec 2006 20:39:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


regression.

Begin forwarded message:

Date: Fri, 1 Dec 2006 20:04:17 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 7616] New: new kernel 2.6.19 causes aic7xxx driver to not work with tape drive


http://bugzilla.kernel.org/show_bug.cgi?id=7616

           Summary: new kernel 2.6.19 causes aic7xxx driver to not work with
                    tape drive
    Kernel Version: 2.6.19
            Status: NEW
          Severity: high
             Owner: scsi_drivers-other@kernel-bugs.osdl.org
         Submitter: freelsjd@ornl.gov
                CC: freelsjd@ornl.gov


Most recent kernel where this bug did *NOT* occur: 2.6.18.4
Distribution: Debian/Stable/Sarge
Hardware Environment: dual-processor AMD opteron
Software Environment: amanda 2.4.4p3-3
Problem Description:

I just tried it out and found that it caused my tape drive (Exabyte 
1x10 changer with VXA-2 tape drive) to not work.  The reason turned 
out to be the Adaptec aic7xxx driver (newer of the two) failed.  
Under 2.6.18.x, this newer driver works fine.  Under 2.6.19 it 
failed.  I then enabled the older (no longer supported) aic7xxx 
driver, disabled the newer one, and it works fine.  The adapter is an 
Adaptec 29160N which is supposed to work fine with the newer aic7xxx 
driver.

Steps to reproduce:

use 2.6.19 fails with new aic7xxx driver
use 2.6.19 works with old aic7xxx driver
use 2.6.18.4 and earlier works with either driver

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
