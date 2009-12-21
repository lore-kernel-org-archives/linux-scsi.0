From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 21 Dec 2009 04:51:49 GMT
Message-ID: <200912210451.nBL4pnJ7016298@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60693 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZLUEvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2009 23:51:50 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBL4pnRd016299
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2009 04:51:49 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #4 from kdesai <kashyap.desai@lsi.com>  2009-12-21 04:51:47 ---
I tried the same test with below setup detail and It works fine for me. Can you
give try upgrading your FW version for 1068 B0 card as mentioned in comment #2.

I used 1068 B0 card and HDD is WesternDigitial SATA drives REVV: 1E01
FW version is 1.29.00.00-IE 
Card Name is SAS3442X.

MPT driver version is 3.4.14 (latest upstream driver). see attachment
fusion_03_04_14.tgz for quick access to fusion driver. You may need to some
change code to make it compilable with your kernel.


Please give a try and let me know your result.

1.29.00 Fw is available at
http://lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/combo/sas3442x-r/index.html

Thanks,
Kashyap

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
