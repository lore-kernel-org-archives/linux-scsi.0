From: ygardi@codeaurora.org
Subject: Re: [PATCH v6 07/15] scsi: ufs: set REQUEST_SENSE command size to 18
 bytes
Date: Mon, 1 Feb 2016 11:39:21 -0000
Message-ID: <717173b8c03452dac13e555e92222032.squirrel@www.codeaurora.org>
References: <1446038045-17102-1-git-send-email-ygardi@codeaurora.org>
    <1446038045-17102-8-git-send-email-ygardi@codeaurora.org>
    <56335FB1.3050301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56335FB1.3050301@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> On 10/28/2015 02:13 PM, Yaniv Gardi wrote:
>> According to UFS device specification REQUEST_SENSE command can
>> only report back up to 18 bytes of data.
>>
>> Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
>> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
> Really? The spec only says that the inline sense code is 18 bytes;
> if you issue a request sense directly there is not such limitation.
>

thanks Hannes,
so for now, i will exclude this patch from the upcoming V7

regards,
Yaniv


> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
