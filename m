From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: fcoe cleanups and fcoe TODO
Date: Mon, 30 Jun 2008 18:33:30 -0500
Message-ID: <48696D4A.1000604@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<10A7D0016239E24092DEF05CCC582E4303FE4B55@fmsmsx411.amr.corp.intel.com>
	<4869539F.3070605@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4869539F.3070605-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "Love, Robert W" <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Love, Robert W wrote:
>>> Hey,
>>>
>>> Following are some cleanup patches for things I found while trying
>>> to get setup. I did not get to test the patches well, because
>>> the rearch code does not seem to work every well the software
>>> target. I basically loaded the driver and made sure I could login
>>> and find storage. Trying to do heavy READ and WRITE IO lead to
>> problems.
>>> The patches are made over the re-arch git tree.
>>>
>> Awesome, I've reviewed a few and will get them in shortly.
> 
> 
> Oh yeah, I just rebased my tree and saw all the checkins from the 
> weekend so my patches do not apply from a tree that is pulled today. Are 
> you going to fix that for me, or do you want me to rediff and resend 
> when you are done reviewing. I heard the iscsi maintainer is really nice 
> and will rediff for you :)

Just kidding the iscsi maintainer is jerk and makes you rediff your 
patches. Here are updated patches against a tree I just downloaded (the 
last commit is cdf23e6d5ad1843054a70a1bcecbffbfd87935b0).

http://kernel.org/pub/linux/kernel/people/mnc/fcoe/6-30-08/
