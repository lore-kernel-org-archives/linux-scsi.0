From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/3] mptfusion : Description Patch
Date: Mon, 26 Jul 2010 18:53:53 +0530
Message-ID: <20100726132344.GA23066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41345 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab0GZOBW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 10:01:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT Fusion driver updates. Please consider it for next rc update.
I have taken patches against 2.6.35-rc6

[PATCH 01/03] mptfusion: Block Error handling for deleting devices or Device in DMD
[PATCH 02/03] mptfusion: Extra debug prints added relavent to Device missing
delay error handling issue.
[PATCH 03/03] mptfusion: Bump version 03.04.17

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
