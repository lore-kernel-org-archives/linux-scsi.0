From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : Description patch.
Date: Mon, 5 Apr 2010 14:17:13 +0530
Message-ID: <20100405084706.GA28900@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45085 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab0DEJTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2010 05:19:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver updates.
Please consider it for next Merge window.
Before applying this patchset previous patch submission for mpt2sas 05.100.00.00
need to be applied.

[PATCH 01/05] mpt2sas: sanity added to remove duplicate port from topology
[PATCH 02/05] mpt2sas: Send default descriptor for RAID pass through in mpt2ctl
[PATCH 03/05] mpt2sas: Added support for PCIe Advanced Error Recovery.
[PATCH 04/05] mpt2sas: Check for NULL pointer before free_pages is added.
[PATCH 05/05] mpt2sas: Upgrade version 05.100.00.01

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
