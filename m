From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 7726] New: New LSI MegaRAID driver fails when
 ACPI is not present
Date: Thu, 21 Dec 2006 12:57:17 -0800
Message-ID: <20061221125717.25f9b15c.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423065AbWLUU5V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Dec 2006 15:57:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>
Cc: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Thu, 21 Dec 2006 10:36:55 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 7726] New: New LSI MegaRAID driver fails when ACPI is not present


http://bugzilla.kernel.org/show_bug.cgi?id=7726

           Summary: New LSI MegaRAID driver fails when ACPI is not present
    Kernel Version: 2.6.17+
            Status: NEW
          Severity: normal
             Owner: scsi_drivers-other@kernel-bugs.osdl.org
         Submitter: bill@crowellsystems.com


Most recent kernel where this bug did *NOT* occur:n/a
Distribution:gentoo
Hardware Environment:i686
Software Environment:gcc 4.1.1, glibc 2.5
Problem Description:
during kernel boot, with noacpi option, megaraid driver detects and attempts to 
start the controller. it fails and goes into an endless loop of error "waiting 
for N commands to finish" and reset sequences.

Steps to reproduce:
boot kernel with acpi disabled using noacpi boot parameter. NOTE this will not 
fail on SMP machines because ACPI is always required. This test is valid only 
on single processor machines.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
