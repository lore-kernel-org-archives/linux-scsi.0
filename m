From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 02/20] [SCSI] mpt3sas: Get IOC_FACTS information using  handshake protocol only after HBA card gets into READY or Operational state.
Date: Fri, 19 Jun 2015 11:03:31 -0400
Message-ID: <yq1r3p7d9ks.fsf@sermon.lab.mkp.net>
References: <1434532251-6897-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41286 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbFSPES (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 11:04:18 -0400
In-Reply-To: <1434532251-6897-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Wed, 17 Jun 2015 14:40:51 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, jthumshirn@suse.de, joe.lawrence@stratus.com

>>>>> " " == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> Driver initialization fails if driver tries to send IOC facts request message when the IOC is in reset or in a fault state.
> 
> This patch will make sure that
>  1.Driver to send IOC facts request message only if HBA is in operational or ready state.
>  2.If IOC is in fault state, a diagnostic reset would be issued.
>  3.If IOC is in reset state then driver will wait for 10 seconds to exit out of reset state.
>    If the HBA continues to be in reset state, then the HBA wouldn't be claimed by the driver.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
