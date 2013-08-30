From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Fri, 30 Aug 2013 04:56:16 +0000
Message-ID: <bug-60644-11613-aNGcm8nd9n@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab3H3E4V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Aug 2013 00:56:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7CE9520384
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2013 04:56:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9BCB02039A
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2013 04:56:18 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #31 from liveaxle@live.com ---
Hi Kurk .

As for the HDDs , here is the list :

Hitachi_HDS5C4040ALE630 (4TB) - (4 disks)

TOSHIBA_DT01ACA300 (3TB) (2 disks)

WDC_WD10EARS-00Y5B1_WD-WCAV5N165986 (1TB) (1 disk)

WDC_WD3200AAJS-00L7A0_WD-WMAV20125236 (320GB) (1 disk)

WDC_WD3200AAKX-001CA0_WD-WCAYUH130479 (320GB) (1 disk)


All of them use BTRFS , which has its own way of partitioning . WHen a new
BTRFS volume is created , it clears the old partition table . And fdisk -l
doesn't show any partitions .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
