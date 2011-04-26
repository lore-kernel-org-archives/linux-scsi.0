From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/3] mptfusion : Description patch
Date: Tue, 26 Apr 2011 12:08:46 +0530
Message-ID: <20110426063843.GB6066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:48847 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756298Ab1DZGTN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2011 02:19:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

MPTFUSION driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
[PATCH 01/03] mptfusion: Remove debug print from mptscsih_qcmd().
[PATCH 02/03] mptfusion: Adding inline data padding support for TAPE drive. 
[PATCH 03/03] mptfusion: Bump version 3.4.19
