From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] SCSI:STORVSC Use SCSI layer to allocate memory for
 per-command device request data
Date: Tue, 10 Mar 2015 15:53:59 +0100
Message-ID: <20150310145359.GA16383@aepfle.de>
References: <1419912309-13518-1-git-send-email-hch@lst.de>
 <20150310114233.GA30423@gmail.com>
 <20150310133036.GA5026@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150310133036.GA5026@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, longli@microsoft.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 10, Christoph Hellwig wrote:

> On Tue, Mar 10, 2015 at 12:42:33PM +0100, Olaf Hering wrote:
> > It would be nice to change .proc_name to KBUILD_MODNAME before v4.0 is
> > released. We carry a patch which adds this field. Of cource we can just
> > change the patch, but if code gets touched upstream anyway...
> 
> Please send a patch.  Would be nice if you had sent it long go insted of just
> including it in a vendor tree..

I was told .procname was dead, but since the patch adds it anyway it
should have a content thats in use (by us).

Olaf
