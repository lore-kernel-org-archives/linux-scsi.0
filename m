From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 0/8] Fix error message and present UFS variant
Date: Tue, 25 Aug 2015 08:47:13 +0900
Message-ID: <CAC5umyg6TNM4XZaq3=ZwyzindB-qjJuzxXtJ=3+G=6T2HE8-EQ@mail.gmail.com>
References: <1440335381-5122-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440335381-5122-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi Yaniv,

2015-08-23 22:09 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> V3: fixes a few minor issues.
>
> V2: fixes a few issues of unnecessary EXPORT_SYMBOL,
> types of parameters in routine definition,
> build errors in case CONFIG_PM is not defined and some
> other minor fixes.

I've checked outstanding issues I reported for v1 and v2 are fixed
in this version of series.  So please feel free to add:

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>

I still think that we should introduce print_hex_dump_io() or
something simpler for dumping __iomem pointer instead of casting
'void __force *'.  But it is only used for debug dump function, so
I don't too much worry about it.
