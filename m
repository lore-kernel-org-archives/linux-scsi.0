From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 7/9] ib_srpt: Convert srp_max_rdma_size into per port
 configfs attribute
Date: Tue, 25 Oct 2011 03:35:53 -0700
Message-ID: <1319538953.20828.0.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-8-git-send-email-nab@linux-iscsi.org>
	 <1319488195.17450.73.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-p9xXB_sWes=uet6skkFn=xWD+vKuoOeuGwjbxYhE-ctg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-p9xXB_sWes=uet6skkFn=xWD+vKuoOeuGwjbxYhE-ctg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-25 at 12:32 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 10:29 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> >> @@ -114,6 +114,7 @@ enum {
> >>       MIN_SRPT_SRQ_SIZE = 4,
> >>       DEFAULT_SRPT_SRQ_SIZE = 4095,
> >>       MAX_SRPT_SRQ_SIZE = 65535,
> >> +     MAX_SRPT_RDMA_SIZE = 256U,
> >>
> >
> > Hey btw, what should the proper MAX_SRPT_RDMA_SIZE be here..?
> 
> As you can see in the ib_srpt source code, the largest value filled in
> for this parameter in the IOC profile is 1U << 24.

Thanks Bart.  Fixing this up now.

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
