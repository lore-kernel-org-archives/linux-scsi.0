From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Sun, 27 Jul 2014 06:52:38 -0700
Message-ID: <20140727135238.GA4641@infradead.org>
References: <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
 <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
 <53A9A702.8050503@dev.mellanox.co.il>
 <20140624163040.GA11499@infradead.org>
 <53A9AEB8.4040104@cs.wisc.edu>
 <53A9B0A0.6000103@cs.wisc.edu>
 <53AA42E6.3090101@cs.wisc.edu>
 <53AA8CF7.8050102@dev.mellanox.co.il>
 <53AAA547.40300@dev.mellanox.co.il>
 <53D4C22F.8050904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53D4C22F.8050904-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <openosd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 27, 2014 at 12:11:11PM +0300, Boaz Harrosh wrote:
> If you have a tree that you want me to test I will be glad too.
> >From this thread I'm confused as to what patches you want me to
> test? please point me to a tree you need testing. You can bug me
> any time, any tree. I will be happy to test.

You're about a month late to the game :)

I think everything is sorted out properly, but if you want to verify
it yourself just test the latest 3.16 release candidate from Linus.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
