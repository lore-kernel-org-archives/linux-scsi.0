From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Please help me to review the patch about supporting SATA PM in LIBSAS
Date: Fri, 18 Apr 2014 12:13:03 -0700
Message-ID: <CAA9_cmeS0_3ge6oRj7MrvD=+Rymk1EVp1JkzREBm-cDGoE=efQ@mail.gmail.com>
References: <CAP0P+NUR1AAxfGT5artyJeD7NNnkq2R=oHJ06VN3zQiLj9qTFw@mail.gmail.com>
	<CAPcyv4iK0NRw1o9nL6YEwm3ymRvvB9799WS+6hE5O7gm5ACH_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:44666 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRTNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2014 15:13:05 -0400
Received: by mail-qg0-f46.google.com with SMTP id 63so1933518qgz.5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2014 12:13:03 -0700 (PDT)
In-Reply-To: <CAPcyv4iK0NRw1o9nL6YEwm3ymRvvB9799WS+6hE5O7gm5ACH_g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xiangliang yu <yxlraid@gmail.com>
Cc: James Bottomley <JBottomley@parallels.com>, Praveen Murali <pmurali@logicube.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Apr 17, 2014 at 9:03 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Apr 16, 2014 at 8:07 PM, xiangliang yu <yxlraid@gmail.com> wrote:
>> hi,
>>
>> The patch is support SATA PM device and can  find all devices that is
>> attached to PM.
>> Until now, i have tested the identified, hot-plug and IO function and
>> result is ok except one mvsas timeout issue.
>> i'll continue to debug mvsas issue, but i don't know whether the
>> libsas code of the patch is ok.
>> So, please help me to review the patch if you feel free. thanks!
>> the patch is as below:
>
> Can you help me with a bit more description on the design of the
> patch?  Details like why you decided to implement pieces the way you
> did, and comments on the difficulties / trade-offs you ran into would
> really be helpful for reviewing.  Not just for me, but for anyone else
> on the mailing list who might be able to offer some review cycles if
> they had a small amount of background on the libsas/libata details.
>

...also, please resend as an attachment so that the whitespace remains in tact.

Thanks.

--
Dan
