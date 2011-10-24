From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 8/9] ib_srpt: Convert srp_max_rsp_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 12:49:12 -0700
Message-ID: <1319485752.17450.57.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-9-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-p24uYKbwqCRWVik63gL-ZABgcJrqAi7ULJZEP+CK1WEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-p24uYKbwqCRWVik63gL-ZABgcJrqAi7ULJZEP+CK1WEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 21:44 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > +static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
> > +       struct se_portal_group *se_tpg,
> > +       const char *page,
> > +       size_t count)
> > +{
> > +       struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
> > +       unsigned long val;
> > +       int ret;
> > +
> > +       ret = strict_strtoul(page, 0, &val);
> 
> If the data "page" points at only consists of digits, the above
> strict_strtoul() call will trigger a past-end-of-buffer read.

I don't understand what you mean here.  Can you provide a test case to
demonstrate please..?

> Also, isn't kstrto*() preferred over strict_strto*() ?
> 

Not AFAIK.

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
