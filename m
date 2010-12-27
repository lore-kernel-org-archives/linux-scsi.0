From: Dave Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [RFC 7/8] IB/srp: stop sharing the host lock with SCSI
Date: Mon, 27 Dec 2010 14:52:00 -0500
Message-ID: <20101227195200.GA5790@thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
 <1293139893-11678-8-git-send-email-dillowda@ornl.gov>
 <1293472165.2896.34.camel@obelisk.thedillows.org>
 <4D18D355.30308@panasas.com>
 <1293472913.2896.36.camel@obelisk.thedillows.org>
 <4D18DF4D.6010607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D18DF4D.6010607-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 27, 2010 at 08:47:41PM +0200, Boaz Harrosh wrote:
> On 12/27/2010 08:01 PM, David Dillow wrote:
> > Oh goodie, I hadn't followed up to see if it was in one of James's later
> > pulls. Thanks for the heads up -- I'll dump scsi_cmd_get_serial() in
> > this patch then.
> > 
> 
> Are these base on James's trees? Or are you maintaining these scsi bits yourself?

The the SRP initiator has historically gone through Roland's Infiniband tree. I
try to base my work on Linus's tree so that Roland doesn't have to deal with
conflicts when he merges my pull request, but sometimes I may need to work
off other trees, and will work it out during the merge window. It's early yet
in our working relationship, so that hasn't come up.

In this case, these are based on a Linus rc just after the lock pushdown.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
