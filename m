From: Michael Clark <michael@metaparadigm.com>
Subject: Re: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: Thu, 18 Apr 2002 11:19:50 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBE3B56.1020408@metaparadigm.com>
References: <71714C04806CD51193520090272892170452B66C@ausxmrr502.us.dell.com> <3CBE1D51.9050300@metaparadigm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Michael Clark <michael@metaparadigm.com>
Cc: Matt_Domsch@Dell.com, mjacob@feral.com, linux-scsi@vger.kernel.org

The SES command set is supposedly documented in the SFF-8067 specification
developed by an X3 committee. I assume is different to SAF-TE and have
removed the reference to it in the readme.

Michael Clark wrote:

> I seem to remember reading somewhere that SAF-TE is component of SES,
> enough so for me to put it in the readme, but I can't back it up as 
> I've never
> had it run on a device that says it is SES capable.
>
> I'd like to know too so I can correct the readme if need be.
>
> cheers,
> ~mc
>
> Matt_Domsch@Dell.com wrote:
>
>>> will it also drive SES?
>>>
>>
>> Some Dell SCSI backplanes are SES capable, I believe that some 
>> aren't.  I'm
>> not sure off-hand of the matrix which is which.  Once we get some 
>> time to
>> investigate further I'll report back our findings.
>>
>> Thanks,
>> Matt
>>
>> -- 
>> Matt Domsch
>> Sr. Software Engineer
>> Dell Linux Solutions www.dell.com/linux
>> Linux on Dell mailing lists @ http://lists.us.dell.com
>> #1 US Linux Server provider for 2001!
>>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



