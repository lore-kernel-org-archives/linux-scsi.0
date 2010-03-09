From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/3] mpt2sas : Description patch
Date: Tue, 9 Mar 2010 16:30:48 +0530
Message-ID: <20100309110034.GB13969@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:39106 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594Ab0CILb3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 06:31:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver updates.
Please consider it for next Merge window.
patch is taken using 2.6.33-rc7.

[PATCH 01/03] mpt2sas: RESCAN Barrier work is added in case of HBA reset.
[PATCH 02/03] mpt2sas: modified _scsih_sas_device_find_by_handle/sas_address
[PATCH 03/03] mpt2sas: Upgrading version to 04.100.01.02

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
