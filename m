From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Separate target visibility from reaped state
	information
Date: Wed, 3 Feb 2016 18:17:27 +0100
Message-ID: <20160203171727.GA4828@lst.de>
References: <568FE922.9090004@sandisk.com> <yq1oachqehs.fsf@sermon.lab.mkp.net> <1453251809.2320.56.camel@HansenPartnership.com> <20160131185455.00000ef7@localhost> <yq160y7q5ku.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43140 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788AbcBCRR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Feb 2016 12:17:29 -0500
Content-Disposition: inline
In-Reply-To: <yq160y7q5ku.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sebastian Herbszt <herbszt@gmx.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Feb 01, 2016 at 08:11:29PM -0500, Martin K. Petersen wrote:
> I am concerned about queuing something as a stable fix if it is just
> masking a fundamental underlying problem.

It's not masking a fundamental problem.  It fixes the target
state so that we can mark a starget as being under deletion
before we have to drop the list protecting the target list
iteration.  Independ of any any other scanning changes it is the
right thing to do.
