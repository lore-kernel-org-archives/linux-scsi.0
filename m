From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCHv3 01/10] mpt3sas: switch to pci_alloc_irq_vectors
Date: Thu, 23 Feb 2017 13:49:07 +0530
Message-ID: <CAK=zhgqNd2F8xE_G-YbsOS5mi6POdHtsF1t8rbjNee23nCEEKA@mail.gmail.com>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
 <1487680029-3701-2-git-send-email-hare@suse.de> <20170222082841.GA22843@lst.de>
 <yq1o9xt7moo.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:32992 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdBWI0L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 03:26:11 -0500
Received: by mail-qk0-f172.google.com with SMTP id n127so25423140qkf.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2017 00:26:11 -0800 (PST)
In-Reply-To: <yq1o9xt7moo.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Thu, Feb 23, 2017 at 6:22 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
>
> Christoph> Martin, can we get at least this patch still in for 4.11?
> Christoph> I'd really like to see as many intance of the old MSI-X
> Christoph> allocation and IRQ affinity mess dead as soon as possible.
>
> Me too. I'll queue it up for 4.11 unless Broadcom objects. And then
> we'll do the rest for 4.12.

This patch looks good. Please consider this patch for 4.11.

We need some time to review remaining patches as it has lot code
refinement and we need to cover some basic test cases.

Thanks,
Sreekanth

>
> --
> Martin K. Petersen      Oracle Linux Engineering
