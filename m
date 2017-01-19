From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 04/17] lpfc: NVME Initiator: Base modifications Part C
Date: Wed, 18 Jan 2017 18:08:11 -0800
Message-ID: <02491936-4bf1-3899-a7a9-b4334d35c58f@gmail.com>
References: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
 <0d7410a8-f7a5-cf97-5c03-c0c2c329f38a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35916 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbdASCIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 21:08:14 -0500
Received: by mail-ot0-f193.google.com with SMTP id 36so2925702otx.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2017 18:08:13 -0800 (PST)
In-Reply-To: <0d7410a8-f7a5-cf97-5c03-c0c2c329f38a@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org



On 1/17/2017 11:17 PM, Hannes Reinecke wrote:
>
>> @@ -3315,16 +3421,121 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
> [ .. ]
> Unsafe.
> 'nvme_xri_cnt' is updated under the lock, but not tested with the lock
> held. Please fix.
>
>

Yep - will fix.

-- james

