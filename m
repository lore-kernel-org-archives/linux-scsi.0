From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9769] CONFIG_SCSI_WAIT_SCAN configure error
Date: Mon, 18 Feb 2008 05:16:24 -0800 (PST)
Message-ID: <20080218131624.60DA811D107@picon.linux-foundation.org>
References: <bug-9769-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbYBRNQ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 08:16:56 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1IDGOTv010230
	for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 05:16:25 -0800
In-Reply-To: <bug-9769-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9769


bkauler@goosee.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REJECTED                    |REOPENED
         Resolution|INVALID                     |




------- Comment #4 from bkauler@goosee.com  2008-02-18 05:16 -------
This is NOT an invalid bug!

In all previous kernels, if
# CONFIG_SCSI_SCAN_ASYNC is not set

then
CONFIG_SCSI_WAIT_SCAN=m
does not even appear in the .config file, and the module
scsi_wait_scan.ko is not built.
The module is NOT built, only in 2.6.24 is it getting built
regardless.

For 2.6.23.x and all earlier kernels, the module is not
built. 

Ditto when doing 'make menuconfig', in all previous kernels,
if CONFIG_SCSI_SCAN_ASYNC is turned off then the option to build
the module is not even offered. However in 2.6.24 it continues
to be offered regardless.

So, I repeat, this is a BUG!

Or, if you have made a change that requires the module to
be built regardless, can you please explain why it is needed
in the case of '.CONFIG_SCSI_SCAN_ASYNC is not set' and why
this change from all previous kernels.

Barry Kauler


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
