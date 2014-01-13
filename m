From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 13 Jan 2014 17:31:38 +0000
Message-ID: <bug-60644-11613-JFJqWY91Sl@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35422 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaAMRbl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 12:31:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EED9F20160
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2014 17:31:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 21FC82012D
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2014 17:31:39 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #38 from Jeff Johnson <jeff.johnson@aeoncomputing.com> ---
Apologies, I forgot to add important information..

I am not running a 3.x kernel, I am running a 2.6 kernel. It would appear that
this problem is a hardware issue (LSI) and not a driver or kernel issue.

I am running:
Linux zfs-0-0.local 2.6.32-279.14.1.el6.x86_64 #1 SMP Tue Nov 6 23:43:09 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux

LSI driver:
filename:       /lib/modules/2.6.32-279.14.1.el6.x86_64/extra/mpt2sas.ko
version:        18.00.01.00
license:        GPL
description:    LSI MPT Fusion SAS 2.0 Device Driver
author:         LSI Corporation <DL-MPTFusionLinux@lsi.com>
srcversion:     ED5DA691FBB263E9F3A55B1



--Jeff

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
