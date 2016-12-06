From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Tue, 6 Dec 2016 18:53:20 +0530
Message-ID: <CAFqt6zbOvrbWPjOMcvRaxucjTQ__RBpg5ErCdtaYbYb-z94SGQ@mail.gmail.com>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15> <CAFqt6zbQn4YivsKG3X5Y2OWK92LaUk5nbe+oUheF111ZONULOw@mail.gmail.com>
 <CAFqt6zbx45Gx4fN4Hv6PZLGsQB8FEK=mjxwAYVNDEpKbOZR+7g@mail.gmail.com> <yq1bmwqvxr6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36575 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbcLFNXW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 08:23:22 -0500
Received: by mail-io0-f175.google.com with SMTP id l140so38463157iol.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2016 05:23:22 -0800 (PST)
In-Reply-To: <yq1bmwqvxr6.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, Rameshwar Sahu <sahu.rameshwar73@gmail.com>, linux-scsi@vger.kernel.org

Hi Martin,

On Tue, Dec 6, 2016 at 3:34 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Souptick" == Souptick Joarder <jrdr.linux@gmail.com> writes:
>
> Souptick,
>
> Souptick> Any comment on this patch?
>
> The patch looked OK to me when you posted it. However, you need one
> person in addition to me to review it. And you need convince us of the
> merit of a presumably untested change to an unmaintained driver.

pci_pool_zalloc() will perform the same as pci_pool_alloc() and memset combined.

I have send similar patches to other modules like - dmaengine, scsi,
net, gpu . Those
were accepted and merged into respective branches. one similar patch
you have applied
previously.

I am sure this patch will work fine even without testing.

>
> --
> Martin K. Petersen      Oracle Linux Engineering

Regards
Souptick
