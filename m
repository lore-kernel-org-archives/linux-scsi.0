From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Tue, 27 Nov 2012 08:42:10 +0200
Message-ID: <50B460C2.9020000@mellanox.com>
References: <cover.1353903448.git.dillowda@ornl.gov>  <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>  <1353957308.2681.5.camel@dabdike> <1353989041.28917.24.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353989041.28917.24.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 27/11/2012 06:04, David Dillow wrote:
> We can push it through James's tree if need be, but Bart's code is 
> pretty self-contained, and going through the SCSI tree will introduce 
> merge dependencies. It'd be much easier to push it all through the 
> RDMA tree

Yep, this makes sense to me even without taking into account the time 
left for the merge window to open,
the patches have been around for long time and relate directly to the 
SRP code in the IB subsystem, there's no point in introducing merge 
dependencies where it can be avoided.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
