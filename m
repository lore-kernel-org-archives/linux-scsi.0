From: <kashyap.desai@lsi.com>
Subject: [PATCH 00/05] mptfusion : Description Patch
Date: Thu, 4 Aug 2011 16:39:31 +0530
Message-ID: <201108041048.p74AmEi0004980@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57688 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab1HDKsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2011 06:48:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, JBottomley@parallels.com

MPTFUSION driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
[PATCH 01/05] mptfusion: Set max sector count module para
[PATCH 02/05] mptfusion: Better handling of DEAD IOC PCI-E LInk down error condition
[PATCH 03/05] mptfusion: Avoid out of order Event processing due to timer migration feature of OS
[PATCH 04/05] mptfusion: Fix for device offline while doing aggressive HBA reset 
[PATCH 05/05] mptfusion: Bump version 3.4.20
