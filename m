From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 23:03:50 +0000
Message-ID: <20050119230350.GA23553@infradead.org>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com> <20050119224016.GA5086@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:25504 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261961AbVASXD5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 18:03:57 -0500
Content-Disposition: inline
In-Reply-To: <20050119224016.GA5086@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 02:40:16PM -0800, Greg KH wrote:
> I had a patch to do that around here somewhere, but I think it was
> rejected as people can get the same info by using 'modinfo' instead.
> You know, the old, "use a userspace tool instead of wasting kernel
> memory" argument :)

How's that supposed to work for builtin drivers?

