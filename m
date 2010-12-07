From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [dm-devel] QUEUE_FLAG_CLUSTER?
Date: Tue, 7 Dec 2010 13:48:49 -0800
Message-ID: <20101207214849.GM14849@kroah.com>
References: <85ABFDC4641C4847BA6088F2982EFD8F04A4A669@nonamew.ptu.promise.com>
 <yq11v627iyv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:37958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab0LGWCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Dec 2010 17:02:48 -0500
Content-Disposition: inline
In-Reply-To: <yq11v627iyv.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ed Lin - PTU <ed.lin@promise.com>, device-mapper development <dm-devel@redhat.com>, Promise_Linux <Promise_Linux@promise.com>, linux-scsi@vger.kernel.org, stable@kernel.org

On Tue, Nov 30, 2010 at 01:40:56PM -0500, Martin K. Petersen wrote:
> >>>>> "Ed" == "Ed Lin <- PTU" <ed.lin@promise.com>> writes:
> 
> Ed> Is it possible to port the patch to previous kernels?
> 
> There's a bit of fuzz due to some of the discard changes and the sysfs
> export of the segment size. But the core of the patch is the same.
> 
> http://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux-2.6-mkp.git
> git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux-2.6-mkp.git
> 
> I've created three branches:
> 
> for-stable-2.6.32.y
> for-stable-2.6.35.y
> for-stable-2.6.36.y

Care to just send me the patches to stable@kernel.org so that I can
apply them?  git trees don't do me much good when I am handling the
stable patches in quilt :(

thanks,

greg k-h
