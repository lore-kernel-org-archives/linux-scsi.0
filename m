From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: NEC ND-4550A problems reading DVD-R
Date: Fri, 04 Mar 2011 09:09:10 -0500
Message-ID: <4D70F286.5040508@earthlink.net>
References: <m339n7g7tw.fsf@intrepid.localdomain> <20110301080153.GA26074@htj.dyndns.org> <4D6CF92A.4020105@teksavvy.com> <4D6D151D.8030307@earthlink.net> <20110304110757.GJ20499@htj.dyndns.org>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110304110757.GJ20499@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mark Lord <kernel@teksavvy.com>, Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 03/04/2011 06:07 AM, Tejun Heo wrote:
> (cc'ing Jens and James)
>
> On Tue, Mar 01, 2011 at 10:47:41AM -0500, Stephen Clark wrote:
>    
>> On 03/01/2011 08:48 AM, Mark Lord wrote:
>>      
>>> On 11-03-01 03:01 AM, Tejun Heo wrote:
>>> ..
>>>        
>>>> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
>>>> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
>>>> block parameter.  Anyways, the drive actually takes longer than 30secs
>>>> to recognize the media?
>>>>          
>>> That slow behaviour is not uncommon, especially as drives struggle
>>> to recognize various forms of copy-protected media (DVD-Video).
>>> A longer default, or tuneable timeout, would help.
>>>        
>> I agree with Mark, this should be a user tuneable value. My 2006 LG
>> dvd-rw frequently times out
>> trying to identify the media. But after numerous timeout error
>> messages it usually suceeds.
>>      
> I don't think it should be a user tunable value.  It should be
> something automatic.  I mean, how many would know to go some cryptic
> place and increase sr probing timeout?
>
> At the same time, increasing it for other cases is quite unattractive,
> so it probably would be a good idea to only use higher timeout value
> for the TUR right after media presence change event.
>
> Anyone interested in doing it?
>
> Thanks.
>
>    
I don't see this as being any different than all the other obfuscated 
tunable values that already
exists. At least I could google or look around for a tunable and maybe 
change it myself instead of having to
patch the source.

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



