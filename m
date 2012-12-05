From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Wed, 5 Dec 2012 23:32:19 +0200
Message-ID: <CAJZOPZKPs5Vx5nB3610V+byv9p1KvL7+sRU6G4uMTRQu=4=STw@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov>
	<CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
	<1353957308.2681.5.camel@dabdike>
	<1353989041.28917.24.camel@obelisk.thedillows.org>
	<CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com>
	<1354242098.3670.3.camel@obelisk.thedillows.org>
	<CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com>
	<50BF9760.2080801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50BF9760.2080801-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 5, 2012 at 8:50 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
[...]
> The only way to make I/O work reliably if a failure can occur at the
> transport layer is to use multipathd on top of ib_srp. If a connection fails
> for some reason, then the SRP SCSI host will be removed after the SCSI error
> handler has finished with its error recovery strategy. And once the
> transport layer is operational again and srp_daemon detects that the
> initiator is no longer logged in srp_daemon will make ib_srp log in again.
> multipathd will then cause I/O to continue over the new path.

Claim basically understood and agreed however, does this also hold
when the link is back again, that is can't SRP login via this single
path also when there's no multipath on top?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
