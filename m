From: Boaz Harrosh <ooo-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org>
Subject: Re: [PATCH 3/4] nfs: remove the objlayout driver
Date: Fri, 21 Apr 2017 16:17:41 +0300
Message-ID: <272aea55-0738-5de2-ca97-414e13b478af@electrozaur.com>
References: <20170412160109.10598-1-hch@lst.de>
 <20170412160109.10598-4-hch@lst.de>
 <1492719505.82584.3.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492719505.82584.3.camel-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, hch <hch-jcswGhMUV9g@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org" <osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/20/2017 11:18 PM, Trond Myklebust wrote:
<>
> 
> OK. I'm applying this patch for the 4.12 merge window. 

That is understandable this code was not tested for a long while

> If, as Boaz
> suggests, there is still an interest in exofs, then I suggest we put
> that to the test by moving it into the STAGING area, to see if someone
> will step up to maintain it.
> 

I do not understand what you mean by "someone will maintain it"
What is it that is missing in exofs that you see needs development?

As I said I regularly run and test this FS and update as things advance
there where no new fixtures for a while, but no regressions either.

Please explain what it means "will maintain it"

> Cheers
>   Trond
> 

Thanks
Boaz

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
