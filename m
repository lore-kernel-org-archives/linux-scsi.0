From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.0 12/16] arcmsr: revise alloction of second
 dma_coherent_handle for type B adapter
Date: Mon, 5 May 2014 12:30:30 +0800
Message-ID: <CAKiknE-9yQJaZSMSsuuiq+snmbUXbbTBYUdCa1u2_t3s8RCSiA@mail.gmail.com>
References: <1398857429.6930.51.camel@localhost>
	<20140502085713.GF4963@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140502085713.GF4963@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Bottomley <jbottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Dan,

This patch is not a bugfix.
It is a simplification and consistency of coding for both adapter type B and D.

Regards,
Ching

2014-05-02 16:57 GMT+08:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Apr 30, 2014 at 07:30:29PM +0800, ching wrote:
>> From: Ching<ching2048@areca.com.tw>
>>
>> Revise allocation of second dma_coherent_handle for type_B adapter.
>>
>
> Is this a bugfix?  I think it is.  Do you know what the user visible
> effects are?
>
> regards,
> dan carpenter
>
