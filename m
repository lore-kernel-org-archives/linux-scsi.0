From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/9] mpt2sas : Discription Patch
Date: Mon, 14 Sep 2009 10:58:56 +0530
Message-ID: <20090914052836.GB31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:60675 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZINFvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 01:51:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver bug fixes. Please consider it for next update.
patch is taken using 2.6.31-rc9.

[PATCH 1/9] mpt2sas: Update driver to MPI2 REV K headers. 
[PATCH 2/9] mpt2sas: Added mpi2_history.txt for MPI2 headers.
[PATCH 3/9] mpt2sas: Copyright change to 2009.
[PATCH 4/9] mpt2sas: Added SCSIIO, Internal and high priority memory pools
to support multiple task managment.
[PATCH 5/9] mpt2sas: Target Reset will be issued from Interrupt context.
[PATCH 6/9] mpt2sas: Call init_completion on a per request basis.
[PATCH 7/9] mpt2sas: Timeout occurred within the HANDSHAKE logic while
waiting on firmware to ACK. 
[PATCH 8/9] mpt2sas: Support dev remove when phy status is MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT. 
[PATCH 9/9] mpt2sas: Bump version 02.100.03.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
