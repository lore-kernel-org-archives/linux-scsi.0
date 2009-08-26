From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 0/7] mpt2sas : [Resend] Discription patch
Date: Wed, 26 Aug 2009 18:50:19 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C14254A4854@inbmail01.lsi.com>
References: <20090820074914.GA17192@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:59815 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbZHZNU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 09:20:26 -0400
In-Reply-To: <20090820074914.GA17192@lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

Any observation for these patches?

Thanks,
Kashyap

-----Original Message-----
From: Kashyap, Desai [mailto:kashyap.desai@lsi.com] 
Sent: Thursday, August 20, 2009 1:19 PM
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
Subject: [PATCH 0/7] mpt2sas : [Resend] Discription patch


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
