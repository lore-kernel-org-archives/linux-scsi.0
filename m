From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 7/9] ib_srpt: Convert srp_max_rdma_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 23:22:19 -0700
Message-ID: <1319523739.17450.289.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-8-git-send-email-nab@linux-iscsi.org>
	 <1319488195.17450.73.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319488195.17450.73.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 13:29 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2011-10-24 at 05:33 +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> > 
> > This patch converts the srp_max_rdma_size module parameter into a per
> > endpoint configfs attribute.  This includes adding the necessary bits
> > for show + store attributes w/ min/max bounds checking, and updating
> > srpt_get_ioc() to accept a struct srpt_port parameter.
> > 
> > Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> > Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> > Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> > Signed-off-by: Nicholas A. Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/srpt/ib_srpt.c |   60 ++++++++++++++++++++++++++++-----
> >  drivers/infiniband/ulp/srpt/ib_srpt.h |   10 +++++
> >  2 files changed, 61 insertions(+), 9 deletions(-)
> > 
> 
> <SNIP>
> 
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
> > index 59ee2d7..c9caa90 100644
> > --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> > @@ -114,6 +114,7 @@ enum {
> >  	MIN_SRPT_SRQ_SIZE = 4,
> >  	DEFAULT_SRPT_SRQ_SIZE = 4095,
> >  	MAX_SRPT_SRQ_SIZE = 65535,
> > +	MAX_SRPT_RDMA_SIZE = 256U,
> >  
> 
> Hey btw, what should the proper MAX_SRPT_RDMA_SIZE be here..?
> 

Ping on this Bart..?

Thanks,

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
