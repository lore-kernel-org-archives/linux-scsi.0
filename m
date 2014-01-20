From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 20 Jan 2014 18:27:44 +0000
Message-ID: <bug-60644-11613-xu9dLpePFI@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52320 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaATS1r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jan 2014 13:27:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2701820181
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2014 18:27:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2DEEC20148
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2014 18:27:45 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #44 from Konstantin <ktrackfd@gmail.com> ---
modinfo mpt2sas

filename:      
/lib/modules/3.12.6-hardened-r4/kernel/drivers/scsi/mpt2sas/mpt2sas.ko
version:        16.100.00.00
license:        GPL
description:    LSI MPT Fusion SAS 2.0 Device Driver
author:         LSI Corporation <DL-MPTFusionLinux@lsi.com>
srcversion:     17F8D55839A477BC4077B0B

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
