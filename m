From: James.Smart@Emulex.Com
Subject: RE: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 14:48:50 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48769 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932391AbVHRStK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 14:49:10 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

> I was trying to avoid the need for an rport object, but I'm 
> not yet sure
> it's feasible.  We certainly won't put in target-persistency support
> similar to FC, that was just a hack to get the existing 
> drivers migrated
> without lots of complaints, it's not going in for new transports like
> SAS or iSCSI. 

This is a heck of a statement... The customers don't see it as SAS vs FC
vs SPI, they just see it as SCSI, and there's a lot of expectations on
consistent behavior. We take a lot of heat defending the community's
position, even from companies that you would have thought had signed on
to the 2.6 behaviors.

I understand the need to push folks to the new 2.6 models, but I fully
expect the same complaints to come from the users of SAS and iSCSI as well.

Please note that by implementing the consistent mappings, you are lessening
the demands on the hba vendor to supply a non-upstream driver that works
around the issue.

> What we might need an rport for is to support SMP.  I'm
> not yet sure how to do SMP passthrough, but we will need some object
> to represent SMP ports.

Depending on how SATA support is implemented, it may be useful for that.

-- james s
