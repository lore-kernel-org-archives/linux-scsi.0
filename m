From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 00/03] mpt2sas : Description Patch
Date: Thu, 8 Apr 2010 17:52:34 +0530
Message-ID: <20100408122222.GA17543@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:44602 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757876Ab0DHMyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 08:54:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

MPT2SAS driver updates.
Please consider it for next Merge window.
To apply this patch set correctly, previos patsets for 05.100.00.01 is
required to be apply.

[PATCH 01/03] mpt2sas: Reworked scmd->result priority for _scsih_qcmd.
[PATCH 02/03] mpt2sas: Before removing sas_device search device in list for
			_scsih_sas_device_remove.
[PATCH 03/03] mpt2sas: Bump version 05.100.00.02

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
