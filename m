From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/3] mpt2sas : Description Patch
Date: Wed, 4 Aug 2010 14:02:18 +0530
Message-ID: <20100804083105.GA13442@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:55719 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207Ab0HDJKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2010 05:10:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver update. Please consider it for Next merge window.

[PATCH 1/3] mpt2sas: Wait for port enable to get complete before reporting
devices to OS.
[PATCH 2/3] mpt2sas: Adding enclosure/slot sorting logic
[PATCH 3/3] mpt2sas: Bump driver version 06.100.00.03

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
