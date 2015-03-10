From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] SCSI:STORVSC Use SCSI layer to allocate memory for
	per-command device request data
Date: Tue, 10 Mar 2015 14:30:36 +0100
Message-ID: <20150310133036.GA5026@lst.de>
References: <1419912309-13518-1-git-send-email-hch@lst.de> <20150310114233.GA30423@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150310114233.GA30423@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: Christoph Hellwig <hch@lst.de>, kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, longli@microsoft.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2015 at 12:42:33PM +0100, Olaf Hering wrote:
> It would be nice to change .proc_name to KBUILD_MODNAME before v4.0 is
> released. We carry a patch which adds this field. Of cource we can just
> change the patch, but if code gets touched upstream anyway...

Please send a patch.  Would be nice if you had sent it long go insted of just
including it in a vendor tree..
