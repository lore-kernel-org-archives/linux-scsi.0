From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Thu, 28 Apr 2016 10:40:14 +0300
Message-ID: <CAJ3xEMj1DoXg8ZFHSXieVT+doU28=pU=QBTUDaf1cYzcn4FMQA@mail.gmail.com>
References: <1460470405-11673-1-git-send-email-hch@lst.de>
	<1460470405-11673-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460470405-11673-3-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 12, 2016 at 5:13 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> So that we don't overflow the number of MR segments allocated because
> we have to split on SGL segment into multiple MR segments.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

nit, but please fix


IB/iser: set [...] --> IB/iser: Set max segment size in the SCSI host template

I prefer to avoid names of variables and functions in commit titles
for the iser initiator driver.

I find the usage of higher language very beneficial for maintenance  and such.

Sagi, I would appreciate if you avoid acking patches lacking this
practice for iser-I,
specifically we want people to use capital letter in the 1st word that
follows that IB/iser: prefix - ok?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
