From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 03/10] scsi_transport_srp: Add transport layer error
 handling
Date: Fri, 25 Oct 2013 18:42:05 -0400
Message-ID: <1382740925.17280.6.camel@frustration.ornl.gov>
References: <52569806.9080201@acm.org> <525699A9.6090802@acm.org>
	 <5262AF8D.7070700@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5262AF8D.7070700-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-10-19 at 18:13 +0200, Bart Van Assche wrote:
> Since it takes some work to figure out the state transitions from the 
> source code, I have tried to draw a diagram representing all state 
> transitions. I have attached that diagram to this e-mail. That diagram 
> probably will make it easier to review this code.

This is handy, Bart -- could you put it in a patch? I suppose it belongs
under Documentation/infiniband...

Thanks!

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
