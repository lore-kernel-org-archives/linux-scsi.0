From: "DIARE,ABOUBACAR (HP-Roseville,ex1)" <aboubacar.diare@hp.com>
Subject: Mid-Layer I/O Throttling
Date: Tue, 10 Feb 2004 14:20:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7A371016E109114EA47C89370296278B01F3065F@xrose01.rose.hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:56730 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S261522AbUBJWUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 17:20:42 -0500
Received: from xparelay1.ptp.hp.com (xparelay1.ptp.hp.com [15.1.28.62])
	by palrel12.hp.com (Postfix) with ESMTP id 1AD6D1C02493
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2004 14:20:42 -0800 (PST)
Received: from xpabh1.ptp.hp.com (xpabh1.ptp.hp.com [15.1.28.60])
	by xparelay1.ptp.hp.com (Postfix) with ESMTP id 129A010053E7
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2004 14:20:42 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Does the Mid-Layer has a mechanism to throttle I/O in response to SCSI queue
fulls?
If Yes, what's the algorithm used?

Thx.

Aboubacar.
