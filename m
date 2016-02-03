From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Wed, 03 Feb 2016 09:54:30 -0800
Message-ID: <1454522070.2338.2.camel@HansenPartnership.com>
References: <568FE922.9090004@sandisk.com>
	 <yq1oachqehs.fsf@sermon.lab.mkp.net>
	 <1453251809.2320.56.camel@HansenPartnership.com>
	 <20160131185455.00000ef7@localhost> <yq160y7q5ku.fsf@sermon.lab.mkp.net>
	 <20160203171727.GA4828@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54910 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965099AbcBCRyd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 12:54:33 -0500
In-Reply-To: <20160203171727.GA4828@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sebastian Herbszt <herbszt@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2016-02-03 at 18:17 +0100, Christoph Hellwig wrote:
> On Mon, Feb 01, 2016 at 08:11:29PM -0500, Martin K. Petersen wrote:
> > I am concerned about queuing something as a stable fix if it is
> > just
> > masking a fundamental underlying problem.
> 
> It's not masking a fundamental problem.  It fixes the target
> state so that we can mark a starget as being under deletion
> before we have to drop the list protecting the target list
> iteration.  Independ of any any other scanning changes it is the
> right thing to do.

It introduces a bug while doing so ... that's a problem.

James


