From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 00/07] : mpt2sas : Description Patch
Date: Tue, 14 Jun 2011 10:54:24 +0530
Message-ID: <20110614052420.GB14349@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:59619 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab1FNE7o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 00:59:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

MPT2SAS driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
[PATCH 01/07] mpt2sas: Fixed Big Indian Issues on 32 bit PPC
[PATCH 02/07] mpt2sas  MPI next revision header update 
[PATCH 03/07] mpt2sas: Set max_sector count from module para.
[PATCH 04/07] mpt2sas: broadcast AEN and task management issue fixed.
[PATCH 05/07] mpt2sas: Added DID_NO_CONNECT return when driver remove and avoid shutdown call
[PATCH 06/07] mpt2sas: Adding support for customer specific branding 
[PATCH 07/07] mpt2sas: Bump version 09.100.00.00
