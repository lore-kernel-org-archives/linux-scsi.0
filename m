From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Make use of UFS_BIT macro wherever possible
Date: Tue, 29 Aug 2017 16:35:13 +0530
Message-ID: <e26087fe-5e1b-c103-668d-43818765d3c9@samsung.com>
References: <CGME20170828122625epcas2p33e3e912339c1e29051ad8e28251ea91b@epcas2p3.samsung.com>
        <1503922783-14317-1-git-send-email-alim.akhtar@samsung.com>
        <1503935147.2841.25.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503935147.2841.25.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Bart,
Thanks for your review.

On 08/28/2017 09:15 PM, Bart Van Assche wrote:
> On Mon, 2017-08-28 at 17:49 +0530, Alim Akhtar wrote:
>> This entire file uses UFS_BIT macro for bits definition, expect for few
>> places. This patch convert those defines to use UFS_BIT macro to be aligned
>> with reset of the file.
> 
> This is the definition of the UFS_BIT() macro I found in
> drivers/scsi/ufs/ufshci.h:
> 
> #define UFS_BIT(x)	(1L << (x))
> 
> Using this macro makes code longer instead of shorter and does not improve
> code readability. Is this macro really useful? Wouldn't it be better to
> remove the UFS_BIT() macro instead of introducing more uses of it?
> 
Well, the intension of this patch is to make use of already existing 
UFS_BIT() macro.

I am not aware of the history why this macro was created at first place.

Well, it does improve code readability, for me at least, no need for one 
to do a calculation to see which bit it is, as we pass _bit_ number to 
UFS_BIT.

I am totally okay, if you or other reviewers suggests me to change 
UFS_BIT to actual bit position, something like the original case, which 
this patch is trying to change.

> Thanks,
> 
> Bart.
> 
Thanks!
Alim
