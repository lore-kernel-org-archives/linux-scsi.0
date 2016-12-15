From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Thu, 15 Dec 2016 10:39:25 +0530
Message-ID: <CAFqt6zbAy_151u8gsuhQUZGk+Yu3pJ-Y6UnjMSRNStd19R=GUw@mail.gmail.com>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15> <20161206132808.GD4818@linux-x5ow.site>
 <CAFqt6zZLJyDJzwQZ6U3T9XG2JwQEOrEQEMYL0yLrbOnjH=yO_A@mail.gmail.com> <yq1oa0fe0pt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36744 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbcLOFJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2016 00:09:36 -0500
Received: by mail-it0-f68.google.com with SMTP id n68so2418994itn.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2016 21:09:26 -0800 (PST)
In-Reply-To: <yq1oa0fe0pt.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, Rameshwar Sahu <sahu.rameshwar73@gmail.com>, linux-scsi@vger.kernel.org

Martin,

On Wed, Dec 14, 2016 at 7:22 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Souptick" == Souptick Joarder <jrdr.linux@gmail.com> writes:
>
> Souptick,
>
> Sorry about the delay. Been out for a few days.
>
>>>> Inside mvs_task_prep(), pci_pool_alloc() followed by memset will be
>>>> replaced by pci_pool_zalloc()
>
> Souptick> Any further comment on this ?
>
> I took one of your other patches because the driver maintainer acked it,
> thus assuming responsibility for testing it and fixing any regressions
> it may cause.
>
> The failure rate on these "trivial" patches to old and unmaintained
> drivers is very high. And since you are not fixing any bugs and your
> change is functionally identical what the code already does, why would
> we merge it and risk a regression? (for changes like this, a Tested-by:
> from somebody with actual hardware is worth a thousand Reviewed-by:
> tags).
>
> Also, I'm not really convinced that this constant churn of new and
> "improved" kernel interface helper functions is really solving anything.
> Quite the contrary. Real bug fixes for drivers adopting the
> pci_pool_zalloc() interface will now potentially be harder to backport
> to stable releases predating 4.4 or whenever that call was introduced.
>
> So in summary, I don't see any actual benefits to your proposed
> change. It's probably fine, but why would I risk merging it?

  I understand the importance of testing this patch on old and
unmaintained driver and
  totally agreed with your point of view now.

  I will drop this patch.
  If possible, can you please let me know what are all the basic
stability test cases are covered
  for SCSI drivers?
>
> Hope that all makes sense...
>
> Thanks!
>
> --
> Martin K. Petersen      Oracle Linux Engineering

Thanks -
Souptick
