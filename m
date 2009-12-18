From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Fri, 18 Dec 2009 15:18:39 GMT
Message-ID: <200912181518.nBIFIdaB015575@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42267 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZLRPSk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2009 10:18:40 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBIFIdZ8015576
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2009 15:18:39 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #2 from Tim Small <tim@seoss.co.uk>  2009-12-18 15:18:37 ---
For the 1068 (Dell PE860):

     Port Name         Chip Vendor/Type/Rev    MPT Rev  Firmware Rev
 1.  /proc/mpt/ioc0    LSI Logic SAS1068 B0      105      000a3300

Current active firmware version is 0.10.51
Firmware image's version is MPTFW-00.10.51.00-IE
  LSI Logic
x86 BIOS image's version is MPTBIOS-6.12.05.00 (2007.09.29)


For the 1068E: (Dell PE1950):
     Port Name         Chip Vendor/Type/Rev    MPT Rev  Firmware Rev
 1.  /proc/mpt/ioc0    LSI Logic SAS1068E 08     105      00192f00

Current active firmware version is 0.25.47
Firmware image's version is MPTFW-00.25.47.00-IE
  LSI Logic
x86 BIOS image's version is MPTBIOS-6.22.03.00 (2008.08.06)


I've just started a test on a SAS1064 (Intel S5000PSL).  Will leave it on test
and report back here...

Thanks,

Tim.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
