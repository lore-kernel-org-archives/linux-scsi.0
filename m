From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 02/17] lpfc: NVME Initiator: Base modifications Part A
Date: Wed, 18 Jan 2017 18:07:31 -0800
Message-ID: <0602b020-2837-1f73-a29c-f44ba5d20722@gmail.com>
References: <587ec2ed.BwM2pzG0hT3uy4dN%jsmart2021@gmail.com>
 <4686b4f0-06ab-d0cc-6630-524f839d6842@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34269 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdASCHe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 21:07:34 -0500
Received: by mail-oi0-f68.google.com with SMTP id w144so2209067oiw.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2017 18:07:34 -0800 (PST)
In-Reply-To: <4686b4f0-06ab-d0cc-6630-524f839d6842@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org



On 1/17/2017 11:07 PM, Hannes Reinecke wrote:
>
>> - * lpfc_sli4_post_scsi_sgl_list - Post blocks of scsi buffer sgls from a list
>> + * lpfc_sli4_post_scsi_sgl_list - Psot blocks of scsi buffer sgls from a list
>>    * @phba: pointer to lpfc hba data structure.
>>    * @post_sblist: pointer to the scsi buffer list.
>>    *
> Psot?

> Repsot? The reverse of 'Psot'?

lol...

>
> bdea?

Crud - caught a bunch of those but looks like a couple got through. 
Surprised checkpatch let them through. oh well.

anyway - will fix and repost (repsot?) what you mentioned.

-- james

