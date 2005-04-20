From: Christoph Hellwig <hch@lst.de>
Subject: Re: 5.x branch mainline kernel push in two weeks?
Date: Wed, 20 Apr 2005 20:31:59 +0200
Message-ID: <20050420183159.GA8775@lst.de>
References: <41EBA11203419D4CA8EB4C6140D8B4010295B3C5@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:5795 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261790AbVDTScR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 14:32:17 -0400
Content-Disposition: inline
In-Reply-To: <41EBA11203419D4CA8EB4C6140D8B4010295B3C5@AVEXCH01.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Duane Grigsby <duane.grigsby@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>, open-iscsi@googlegroups.com, linux-iscsi development team <linux-iscsi-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Wed, Apr 20, 2005 at 11:29:12AM -0700, Duane Grigsby wrote:
> No, that's not true; we are TOTALLY committed to getting all of our
> drivers in the upstream kernel. I have been working on the ISCSI driver
> cleanup to the level of our Fibre Channel driver as Andrew has done. I'm
> making it conform to the current linux-scsi API, ISCSI transport, and
> stripping out all of the failover baggage. My goal is the have something
> upstream in 2 - 3 weeks, if not before.   

Okay, sorry for implying the opposite.

So what API are you using for communicating with userspace right now?
How much userspace support do you need?  Is the current iscsi transport
class okay with you and what about the netlink version?

It would be very helpful to have you participating on the various iscsi
transport class and userspace interface discussions.
