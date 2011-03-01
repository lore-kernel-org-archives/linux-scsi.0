From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: NEC ND-4550A problems reading DVD-R
Date: Tue, 01 Mar 2011 10:47:41 -0500
Message-ID: <4D6D151D.8030307@earthlink.net>
References: <m339n7g7tw.fsf@intrepid.localdomain> <20110301080153.GA26074@htj.dyndns.org> <4D6CF92A.4020105@teksavvy.com>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D6CF92A.4020105@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Tejun Heo <tj@kernel.org>, Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/01/2011 08:48 AM, Mark Lord wrote:
> On 11-03-01 03:01 AM, Tejun Heo wrote:
> ..
>    
>> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
>> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
>> block parameter.  Anyways, the drive actually takes longer than 30secs
>> to recognize the media?
>>      
> That slow behaviour is not uncommon, especially as drives struggle
> to recognize various forms of copy-protected media (DVD-Video).
> A longer default, or tuneable timeout, would help.
>
> Cheers
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
I agree with Mark, this should be a user tuneable value. My 2006 LG 
dvd-rw frequently times out
trying to identify the media. But after numerous timeout error messages 
it usually suceeds.

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



