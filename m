From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [PATCH] megaraid_sas: fix compat ioctl handling
Date: Thu, 6 Oct 2005 10:03:52 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD222@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47294 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751011AbVJFOEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2005 10:04:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

>
>> MEGASAS_IOC_FIRMWARE32 which is defined outside 
>CONFIG_COMPAT is using 
>> struct compat_megasas_iocpacket which is inside the 
>CONFIG_COMPAT. It 
>> still works because MEGASAS_IOC_FIRMWARE32 is not referenced 
>elsewhere 
>> in the code. I wasn't sure if you inteneded this to be like this (to 
>> force driver not to use FIRMWARE32 value in outside CONFIG_COMPAT).
>
>as you said it shouldn't matter.  if you prefer it inside the 
>ifdef I can send an incremental patch to fix it up.
>
No, it is fine as it is now. Thanks.
