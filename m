From: Christoph Hellwig <hch@lst.de>
Subject: Re: 5.x branch mainline kernel push in two weeks?
Date: Wed, 20 Apr 2005 10:49:18 +0200
Message-ID: <20050420084918.GA345@lst.de>
References: <1113844382.13939.230.camel@beastie> <20050418181352.GA2983@lst.de> <426612D7.3010701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:11158 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261493AbVDTIt2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 04:49:28 -0400
Content-Disposition: inline
In-Reply-To: <426612D7.3010701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-iscsi development team <linux-iscsi-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Wed, Apr 20, 2005 at 01:29:11AM -0700, Mike Christie wrote:
> Are you going to try and push someone like qla4010 which has a similar 
> interface to qla2xxx (it uses the msg box interface) to use the netlink 
> interface? With a lot of the iscsi stuff masked away it seems a little 
> difficult to go the extent open-iscsi did?

I'm not sure we should care too much about the qla4xxx driver.  It's
never been posted to linux-scsi, and the driver they pushed to SuSE
ignores everything we've said about scsi low-level drivers.  It looks
like the iSCSI part of Qlogic simply doesn't care about Linux (that is
upstream, not the major forks)
