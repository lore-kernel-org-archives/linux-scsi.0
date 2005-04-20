From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: 5.x branch mainline kernel push in two weeks?
Date: Wed, 20 Apr 2005 11:29:12 -0700
Message-ID: <41EBA11203419D4CA8EB4C6140D8B4010295B3C5@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:42686 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261788AbVDTS3S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 14:29:18 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, open-iscsi@googlegroups.com
Cc: linux-iscsi development team <linux-iscsi-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

No, that's not true; we are TOTALLY committed to getting all of our
drivers in the upstream kernel. I have been working on the ISCSI driver
cleanup to the level of our Fibre Channel driver as Andrew has done. I'm
making it conform to the current linux-scsi API, ISCSI transport, and
stripping out all of the failover baggage. My goal is the have something
upstream in 2 - 3 weeks, if not before.   

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Wednesday, April 20, 2005 1:49 AM
To: open-iscsi@googlegroups.com
Cc: linux-iscsi development team; linux-scsi@vger.kernel.org
Subject: Re: 5.x branch mainline kernel push in two weeks?

On Wed, Apr 20, 2005 at 01:29:11AM -0700, Mike Christie wrote:
> Are you going to try and push someone like qla4010 which has a similar

> interface to qla2xxx (it uses the msg box interface) to use the
netlink 
> interface? With a lot of the iscsi stuff masked away it seems a little

> difficult to go the extent open-iscsi did?

I'm not sure we should care too much about the qla4xxx driver.  It's
never been posted to linux-scsi, and the driver they pushed to SuSE
ignores everything we've said about scsi low-level drivers.  It looks
like the iSCSI part of Qlogic simply doesn't care about Linux (that is
upstream, not the major forks)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

