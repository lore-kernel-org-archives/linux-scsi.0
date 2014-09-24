From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Wed, 24 Sep 2014 16:38:56 +0300
Message-ID: <5422C970.4050306@dev.mellanox.co.il>
References: <541C27BF.6070609@acm.org> <541C28E0.7010705@acm.org> <5421A093.1070203@dev.mellanox.co.il> <5421C3DF.5000102@acm.org> <5422B78B.4000501@dev.mellanox.co.il> <5422C395.7090902@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5422C395.7090902-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 9/24/2014 4:13 PM, Bart Van Assche wrote:
> On 24/09/2014 6:22, Sagi Grimberg wrote:
>> Since SRP_LOGIN_REQ/RESP has some free bits why not declare it and
>> activate it when both sides *says* they support it? I'd be much calmer
>> knowing we're on the safe side on this...
>
> Hello Sagi,
>
> Since more than ten years the SRP protocol is an official ANSI standard.
> Since multichannel support has been defined in that standard my
> preference is to follow what has been documented in that standard with
> regard to multichannel operation.

Just re-visited the r16a, srp_login request req_flags include MULTI
CHANNEL ACTION (Table 10) and srp login response rsp_flags include
MULTI-CHANNEL RESULT (Table 12).

Did you notice those? Didn't see any reference in the patch...

  Using one of the free bits in the SRP
> login request and response would involve a protocol modification. Hence
> the proposal to add a blacklist for non-conforming target implementations.
>

So I'm not so sure we need to update SRP login sequence...

>> Plus, I would like to run it on my performance setups. can you point me
>> to the SCST repo? is multichannel supported in scst trunk?
>
> I think multichannel support was already present in the SCST SRP target
> driver before I started maintaining that driver. However, last April a
> few patches were checked in to improve multichannel support in the SCST
> SRP target driver. These patches have been included in the SCST 3.0
> release. Download instructions for SCST (3.0 and trunk) can be found
> e.g. here: http://scst.sourceforge.net/downloads.html.
>

Thanks,

P.S.
Would it be possible to break 8/8 into more patches in the next round?
it would help make it more review-able?

Thanks,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
