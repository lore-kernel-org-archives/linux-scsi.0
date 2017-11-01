From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 2/8] crypto: scompress - use sgl_alloc() and sgl_free()
Date: Wed, 1 Nov 2017 15:17:06 +0000
Message-ID: <CAKv+Gu_-pqqVn5QeuM_OR0itQS-v5uFATt-ZzNDmPy8CHSLrGg@mail.gmail.com>
References: <20171016224940.1332-1-bart.vanassche@wdc.com> <20171016224940.1332-3-bart.vanassche@wdc.com>
 <1509547836.2530.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:51373 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753474AbdKAPRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2017 11:17:07 -0400
Received: by mail-io0-f178.google.com with SMTP id b186so6747195iof.8
        for <linux-scsi@vger.kernel.org>; Wed, 01 Nov 2017 08:17:07 -0700 (PDT)
In-Reply-To: <1509547836.2530.1.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>

On 1 November 2017 at 14:50, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Mon, 2017-10-16 at 15:49 -0700, Bart Van Assche wrote:
>> Use the sgl_alloc() and sgl_free() functions instead of open coding
>> these functions.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>
> Ard and/or Herbert, can you please have a look at this patch and let us know
> whether or not it looks fine to you?
>

The patch itself does not look unreasonable, but I can't find
sgl_alloc() anywhere in the source tree. Given that you have cc'ed me
on this patch only, I can only assume that you are adding this as part
of the series, but without any context, I can't really review this,
sorry.
