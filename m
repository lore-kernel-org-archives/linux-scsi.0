From: ygardi@codeaurora.org
Subject: Re: [PATCH v2 0/8] Fix error message and present UFS variant
Date: Tue, 25 Aug 2015 11:49:50 -0000
Message-ID: <a6f707bd57a50b3ee5b6dcdd3d5bb53a.squirrel@www.codeaurora.org>
References: <1440335381-5122-1-git-send-email-ygardi@codeaurora.org>
    <CAC5umyg6TNM4XZaq3=ZwyzindB-qjJuzxXtJ=3+G=6T2HE8-EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAC5umyg6TNM4XZaq3=ZwyzindB-qjJuzxXtJ=3+G=6T2HE8-EQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Thank you Mita,
We appreciate your comments and your time.

will add "Reviewed-by".

regards,
Yaniv


> Hi Yaniv,
>
> 2015-08-23 22:09 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>> V3: fixes a few minor issues.
>>
>> V2: fixes a few issues of unnecessary EXPORT_SYMBOL,
>> types of parameters in routine definition,
>> build errors in case CONFIG_PM is not defined and some
>> other minor fixes.
>
> I've checked outstanding issues I reported for v1 and v2 are fixed
> in this version of series.  So please feel free to add:
>
> Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
>
> I still think that we should introduce print_hex_dump_io() or
> something simpler for dumping __iomem pointer instead of casting
> 'void __force *'.  But it is only used for debug dump function, so
> I don't too much worry about it.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
