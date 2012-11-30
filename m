From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Thu, 29 Nov 2012 21:21:38 -0500
Message-ID: <1354242098.3670.3.camel@obelisk.thedillows.org>
References: <cover.1353903448.git.dillowda@ornl.gov>
	 <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
	 <1353957308.2681.5.camel@dabdike>
	 <1353989041.28917.24.camel@obelisk.thedillows.org>
	 <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-29 at 12:21 -0800, Roland Dreier wrote:
> On Mon, Nov 26, 2012 at 8:04 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > We can push it through James's tree if need be, but Bart's code is
> > pretty self-contained, and going through the SCSI tree will introduce
> > merge dependencies. It'd be much easier to push it all through the RDMA
> > tree, especially if we want to get this landed for 3.8.
> 
> OK, I guess all the srp_transport stuff looks quite simple and good to
> me, so I'm OK merging it.
> 
> Is there some subset of patches that you and Bart agree are good,
> which I can pick up now?  I'd love to get at least some of the SRP
> stuff into 3.8, and that window is opening pretty soon.

Modulo a few style issues (braces around one line if branches, etc.) and
having three state variables vs one, I can live with everything up to
aabfa852acd27962 at git://github.com/bvanassche/linux.git#srp-ha. Those
two are small things that can be fixed later and are not worth holding
things up any further.

I'll try to spend some time on the final four patches tomorrow
afternoon.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
