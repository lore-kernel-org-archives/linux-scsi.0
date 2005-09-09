From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SAS transport class
Date: Fri, 09 Sep 2005 09:35:36 -0500
Message-ID: <1126276536.4799.5.camel@mulgrave>
References: <20050909142250.GA13136@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43943 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964914AbVIIOfq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 10:35:46 -0400
In-Reply-To: <20050909142250.GA13136@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-09-09 at 16:22 +0200, Christoph Hellwig wrote:
> In addition to the basic SCSI core objects this transport class introduces
> two additional intermediate objects:  The SAS PHY as represented by struct
> sas_phy defines an "outgoing" PHY on a SAS HBA or Expander, and the SAS
> remote PHY represented by struct sas_rphy defines an "incoming" PHY on a
> SAS Expander or end device.  Note that this is purely a software concept, the
> underlying hardware for a PHY and a remote PHY is the exactly the same.

My only real comment is that an outgoing PHY should probably exist in a
separate class because that concept is common to SATA, so the class
should be shareable between sas/sata.

What you call a sas_rphy, when it's an expander input is the thing we're
going to want to attach an SMP tap to for the management tools
(eventually).

> I think this submission is ready for 2.6.14, but additional comments are
> of course very welcome.

Hmm ... OK ... we can try this in rc-fixes at first.

James


