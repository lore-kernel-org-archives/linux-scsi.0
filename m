From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC] sd: dynamically adjust SD_MAX_WS16_BLOCKS as per the actual
 logical block size
Date: Sun, 14 Aug 2016 16:46:00 +0800
Message-ID: <CAGnHSEmh7ckOksN3T64nLtTax0aaQYN67h+j-YwYwBw3ihTf6A@mail.gmail.com>
References: <b7f44789e0e68fa57d2e3cd059ac3a5bc6d53495.1470954520.git.tom.ty89@gmail.com>
 <yq1bn0yptqq.fsf@sermon.lab.mkp.net> <CAGnHSEk1UG1CaX+2zv20ONxnM7XavGvW9kX2KSPy7R7ZoKL_pA@mail.gmail.com>
 <yq1shu9n37h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1shu9n37h.fsf@sermon.lab.mkp.net>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On 13 August 2016 at 04:26, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:
>
> Tom,
>
> Tom> I don't really follow. What would this BLK_MAX_BIO_SECTORS be? It
> Tom> doesn't appear to me that a static value is going to address the
> Tom> problem I am addressing in this patch.
>
> 0x7fffff, the maximum number of block layer sectors that can be
> expressed in a single bio.

Hmm, so when we queue any of the limits, we convert a certain maximum
number of physical sectors (which we has already been doing) to its
corresponding maximum number of block layer sectors, and then make
sure that number does not exceed 0x7fffff, right?

>
> --
> Martin K. Petersen      Oracle Linux Engineering
