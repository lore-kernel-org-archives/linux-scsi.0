From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] mptsas: fix undefined behaviour of a shift of an int by
 more than 31 places
Date: Wed, 8 May 2019 14:07:16 +0100
Message-ID: <de7e3aaf-0155-5007-c228-510f0d0de428@canonical.com>
References: <20190504164010.24937-1-colin.king@canonical.com>
 <1557027274.2821.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1557027274.2821.2.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/05/2019 04:34, James Bottomley wrote:
> On Sat, 2019-05-04 at 17:40 +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the shift of int value 1 by more than 31 places can result
>> in undefined behaviour. Fix this by making the 1 a ULL value before
>> the shift operation.
> 
> Fusion SAS is pretty ancient.  I thought the largest one ever produced
> had four phys, so how did you produce the overflow?

This was an issue found by static analysis with Coverity; so I guess
won't happen in the wild, in which case the patch could be ignored.

Colin

> 
> James
> 
