From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [PATCH] sparse __iomem annotations for qla2xxx
Date: Mon, 18 Oct 2004 09:00:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD05A9@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:56473 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S266511AbUJRP52 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 11:57:28 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Saturday, October 09, 2004 6:42 AM, Christoph Hellwig wrote:
> this also found a real bug, qla2xxx isn't iounmapping at host
> removal at
> all currently - and if the right cpp macro would have been set it'd
> be too late. 
>

Thanks for catching this.  James please apply.

Regards,
Andrew Vasquez
