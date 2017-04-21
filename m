From: James Smart <james.smart@broadcom.com>
Subject: Re: ["PATCH-v2" 00/22] lpfc updates for 11.2.0.12
Date: Fri, 21 Apr 2017 09:44:28 -0700
Message-ID: <3375ebb0-7711-d55f-ee11-22dff1085555@broadcom.com>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
 <a8ba07f3-348e-4ae4-010b-1c9ff63b6f0d@grimberg.me>
 <20170421062258.GA30237@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33046 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423580AbdDUSVx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 14:21:53 -0400
Received: by mail-oi0-f46.google.com with SMTP id y11so74281537oie.0
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 11:21:52 -0700 (PDT)
In-Reply-To: <20170421062258.GA30237@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>
Cc: jsmart2021@gmail.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, martin.petersen@oracle.com

On 4/20/2017 11:22 PM, Christoph Hellwig wrote:
> On Fri, Apr 21, 2017 at 02:52:13AM +0300, Sagi Grimberg wrote:
>>> The patches are dependent on the FC nvme/nvmet patches from the following 2
>>> series:
>>> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009250.html
>>> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009256.html
>> Hmm,
>>
>> So it seems that we have conflicts here
>>
>> A local merge attempt on Jens's current for-4.12/block
>> from nvme-4.12 (with this patchset)is generating:
> The problem are two patches from the "nvme_fc: add ctlr reset support
> and abort fixes" series from James which conflict badly with the NVMe
> result/state rework in block/for-next.
>
> I will drop this series from nvme-4.12 for now, and rebase nvme-4.12
> on top of Jens' for-4.12 tree so that we have a good base to start
> from.  I think we can get James' patch in post-rc1 or wih a second
> pull request still.
>
> Also James once you do that please run the patches through sparse,
> there are a few warnings in the changes, although they mostly seem
> to replace old warnings with different ones.
looking back, looks like I didn't reback to the latest block tree, so 
the conflicts exist.   I'm having a hard time believe the conflicts are 
that egregious. Almost all of these mods are internal or toward the fc 
facing side.    I'll reback vs block and nvme-4.12 and will look to repost.

-- james
