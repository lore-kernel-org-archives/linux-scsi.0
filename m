From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Thu, 15 Dec 2011 15:20:33 -0500
Message-ID: <1323980433.16703.78.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012010.37276.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012010.37276.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-01 at 20:10 +0100, Bart Van Assche wrote:
> Add the necessary functions in the SRP transport module to allow
> an SRP initiator driver to implement transport layer recovery.

I've run out of time today to look further, but I did want to point out
that I think you're doing way too much in this patch. I like that you're
moving some pieces into the transport, as it would be good to handle
in-fabric/out-of-fabric there as well, as done for the FC transport.
Getting there needs to be done through a series of patches rather one
big patches, especially since you're touching code that multiple drivers
use and need to get the core changes reviewed by so many people. I would
need some quite some persuasion to be comfortable making large changes
to srp_transport through the IB tree without ack's by Fujita and Brian.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
