From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] pm80xx: remove the SCSI host before detaching from SAS
	transport
Date: Tue, 3 Nov 2015 14:14:37 +0100
Message-ID: <20151103131437.GA6426@lst.de>
References: <1446235297-4572-1-git-send-email-brood@attotech.com> <CAD+HZHV_6BKVuqw8O1c58mPY4=LvJov0ZkWaaxYOWQw=EMg0EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58076 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbbKCNOk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2015 08:14:40 -0500
Content-Disposition: inline
In-Reply-To: <CAD+HZHV_6BKVuqw8O1c58mPY4=LvJov0ZkWaaxYOWQw=EMg0EA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: Benjamin Rood <benjaminjrood@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

On Mon, Nov 02, 2015 at 09:29:13AM +0100, Jack Wang wrote:
> Thanks for digging it down. Looks good to me.
> 
> Seems other libsas based driver all affected, maybe we should also fix them?
> Christoph (cc-ed), could you share your opinion about this fix, as the
> commit cff549e4860f is from you?

scsi_remove_host should be done first in ->remove and the commit
was written under that assumption.  So it looks like the other drivers
will need fixes as well.
