From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: Re: new kernel = megaraid performance cut in half
Date: Thu, 16 May 2002 08:39:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE3E0B3.4000108@aptalaska.net>
References: <Pine.LNX.4.44.0205161049170.1330-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mikael Abrahamsson wrote:
> On Tue, 14 May 2002, Matthew Schumacher wrote:
> 
> 
>>Is there anything I can do to resolve the speed issue so that I can 
>>continue using the 2.4.18 kernel?  This box is serving mail so 21MB sec 
>>on 3x10000rpm scsi3 disks in a raid 5 array is not acceptable.
> 
> 
> I am running 7.3 (upgraded from 7.2) and I feel that the 2.4.18 kernel
> with the new VM code is actually inferior to that of 2.4.9-31. I have lots
> of memory (1.2 gig) and lots of disk access, and I see more swap and worse
> interactive performance on 2.4.18 (redhat supplied kernel) as compared to 
> the redhat supplied 2.4.9-31 for 7.2.
> 


Hmm, the reason why I upgraded to 2.4.18 in the first place was to fix a 
bunch of problems with quota.  I wonder if 2.4.9-31 will work with the 
quotas correctly, I was on 2.4.7.

schu

