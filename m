From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Fri, 7 Dec 2012 10:19:15 +0200
Message-ID: <CAJZOPZK58eDMLjsO2VU0kOLCfmRqsM2g3_GcR+VNQUeBHYrJuA@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov>
	<CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
	<1353957308.2681.5.camel@dabdike>
	<1353989041.28917.24.camel@obelisk.thedillows.org>
	<CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com>
	<1354242098.3670.3.camel@obelisk.thedillows.org>
	<CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com>
	<50BF9760.2080801@acm.org>
	<CAJZOPZKPs5Vx5nB3610V+byv9p1KvL7+sRU6G4uMTRQu=4=STw@mail.gmail.com>
	<50C0A76C.20500@acm.org>
	<50C0AB42.8040402@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C0AB42.8040402-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 6, 2012 at 4:27 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
[...]
> looking on the current locks in the system, we see that this kworker task
> holds four locks, but none of them seems  to be mutually held by another task,

That was ofcourse a wrong assertion, as a lock can't be mutually held
by two tasks...
I wanted to say that from the general view of which locks are being
held there's no obvious deadlock here, since none of the other locks
holders relates to the block/scsi layers...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
