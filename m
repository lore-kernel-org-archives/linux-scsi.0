From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 0/7] mpt2sas : [Resend] Discription patch
Date: Thu, 20 Aug 2009 13:19:22 +0530
Message-ID: <20090820074914.GA17192@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:36005 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZHTILF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 04:11:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


MPT2SAS driver changes. Please consider it for next update.
patch is taken using 2.6.31-rc6.


[PATCH 1/7] mpt2sas: Rescan topology from Interrupt context instead of
worker thread context 
[PATCH 2/7] mpt2sas: Prevent sending command to FW while Host Reset. 
[PATCH 3/7] mpt2sas: Removed wrapper funtions _scsih_link_change.
[PATCH 4/7] mpt2sas: setting SDEV into RUNNING state from Interrupt context 
[PATCH 5/7] mpt2sas: Raid 10 Volume is showing as Raid 1E in dmesg
[PATCH 6/7] mpt2sas: cleanup interrupt routine and config_request
optimization. 
[PATCH 7/7] mpt2sas: Bump driver version 01.100.06.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <Eric.moore@lsi.com>
---
