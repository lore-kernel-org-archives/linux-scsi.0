From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH] be2iscsi: switch to pci_alloc_irq_vectors
Date: Mon, 23 Jan 2017 09:41:45 +0530
Message-ID: <29f55cdbd89162f2885494cd7d0472db@mail.gmail.com>
References: <1484324988-30962-1-git-send-email-hch@lst.de> <yq1lgu5gswf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34888 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbdAWELr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jan 2017 23:11:47 -0500
Received: by mail-ua0-f171.google.com with SMTP id y9so102086427uae.2
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jan 2017 20:11:47 -0800 (PST)
In-Reply-To: <yq1lgu5gswf.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Saturday, January 21, 2017 5:56 AM
> To: Christoph Hellwig
> Cc: subbu.seetharaman@broadcom.com; ketan.mukadam@broadcom.com;
> jitendra.bhivare@broadcom.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] be2iscsi: switch to pci_alloc_irq_vectors
>
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
>
> Christoph> And get automatic MSI-X affinity for free.
>
> Jitendra?
>
We will be taking this up along with some other changes in the same area.

Regards,

JB
