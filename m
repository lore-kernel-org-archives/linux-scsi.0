From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCHv2] mpt3sas: switch to pci_alloc_irq_vectors
Date: Fri, 6 Jan 2017 21:19:31 +0530
Message-ID: <CAK=zhgp63d3z5kBD+F6SKuWneiqByPH43BcrkoEywfqjM0tkAA@mail.gmail.com>
References: <1482240421-14847-1-git-send-email-hare@suse.de> <yq1wpe9hsix.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34070 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936231AbdAFPtd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2017 10:49:33 -0500
Received: by mail-qk0-f172.google.com with SMTP id a20so79006840qkc.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2017 07:49:32 -0800 (PST)
In-Reply-To: <yq1wpe9hsix.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Fri, Jan 6, 2017 at 7:13 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
>
> Hannes> Cleanup the MSI-X handling allowing us to use the PCI-layer
> Hannes> provided vector allocation.
>
> Sreekanth, Sathya: Please review!

Martin,

We have started some testing on this patch and we will provide our
review comments by end of next week.

Thanks,
Sreekanth
>
> --
> Martin K. Petersen      Oracle Linux Engineering
