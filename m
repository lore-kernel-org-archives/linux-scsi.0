From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 00/18, v2] Make ib_srp better suited for H.A. purposes
Date: Mon, 05 Mar 2012 01:13:28 -0500
Message-ID: <1330928009.31361.9.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus>
	 <1326579013.8227.4.camel@obelisk.thedillows.org>
	 <CAO+b5-qv0LRFZ3QkyS+bFXF7Sx7WPeqgSX3q5Ph-jCFKNU0uCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qv0LRFZ3QkyS+bFXF7Sx7WPeqgSX3q5Ph-jCFKNU0uCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-01-15 at 09:28 +0000, Bart Van Assche wrote:
> On Sat, Jan 14, 2012 at 10:10 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > Patch 17 (srp_transport: Add transport layer recovery support) doesn't
> > apply with 'git am'. I haven't investigated why yet, so it may be quite
> > simple.
> 
> Hmm, that's strange. As far as I can see what arrived on the
> linux-scsi mailing list is identical to the patches I prepared, and
> I've just checked that these apply cleanly on top of Linus' tree. By
> the way, this patch series is available on github too:
> http://github.com/bvanassche/linux/commits/srp-ha/

I suspect it was the local Exchange server substituting spaces for the
tabs; git am was upset with the white space damage. If you can put a URL
in the cover letter, that will be quite helpful for future reviews.

I'm a bit worried about the lack of comments from others about your
changes to scsi_transport_srp.*. We really should see some ACKs from the
SCSI guys, and while I would think they should go via James Bottomley
rather than Roland, I don't think that going through the InfiniBand tree
will be a real issue if James is OK with them.

However, given the lack of any comments from that side, I wonder if it
makes any sense to contain the changes to the initiator for now, and
then migrate the common functionality to the transport layer via the
SCSI tree as we can get the right people's attention?

I'm not particularly happy with that approach, as I'd rather we do it
correctly the first time, but I know people would like to see the
improvements in the SRP initiator as well.

What do others think?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
