From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 16:53:54 +0100
Message-ID: <20050823155354.GA4645@parcelfarce.linux.theplanet.co.uk>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050823154232.GA3464@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5251 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S1751144AbVHWPvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 11:51:03 -0400
Content-Disposition: inline
In-Reply-To: <20050823154232.GA3464@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Smart@Emulex.Com, luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Tue, Aug 23, 2005 at 08:42:32AM -0700, Patrick Mansfield wrote:
> As others stated, id is already a tag/label. You should be able to pass
> whatever id you want to scsi_scan_target, like the FC ID (port_id), and
> then we also want an abstract iterator in fc transport for the id for
> usage in scsi_scan.c:scsi_scan_channel. Then you can lose all the
> fc_host->next_target_id code.
> 
> Printing of them won't be so nice, we should have used hex values in our
> device's bus_id.

Definitely.  PCI does, so SCSI should too.  Most non-enterprise users
won't even notice because all their LUNs are below 8 anyway.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
