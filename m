From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Wed, 15 Sep 2004 14:13:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915131311.GD642@parcelfarce.linux.theplanet.co.uk>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com> <4147C38C.3000104@torque.net> <414839F0.20008@rtr.ca> <20040915125545.GE4111@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49558 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264113AbUIONNQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 09:13:16 -0400
Content-Disposition: inline
In-Reply-To: <20040915125545.GE4111@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mark Lord <lsml@rtr.ca>, dougg@torque.net, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Wed, Sep 15, 2004 at 02:55:46PM +0200, Jens Axboe wrote:
> The remaining piece (well the biggest one at least) is a nice /dev/disk
> abstraction. That's currently the biggest obstacle to nice generic block
> drivers, not the infrastructure.

I'll just take this opportunity to plug /dev/drive over /dev/disk.
Not only does it avoid the disc/disk dialect problem, it is also more
accurate in the case of removable media.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
