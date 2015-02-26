From: brace <brace@pmcs.com>
Subject: RE: [PATCH 02/43] hpsa: clean up host, channel, target, lun prints
Date: Thu, 26 Feb 2015 14:50:54 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB38D5D955@BBYEXM01.pmc-sierra.internal>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221741.21954.90751.stgit@brunhilda>
 <20150223201608.GB11037@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:49419 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932084AbbBZOu4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2015 09:50:56 -0500
In-Reply-To: <20150223201608.GB11037@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, Justin Lindley <Justin.Lindley@pmcs.com>, brace <brace@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

done

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, February 23, 2015 2:16 PM
> To: Don Brace
> Cc: Scott Teel; Kevin Barnett; james.bottomley@parallels.com;
> hch@infradead.org; Justin Lindley; brace; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 02/43] hpsa: clean up host, channel, target, lun prints
> 
> > +	dev_info(&h->pdev->dev,
> > +		"%6s scsi %d:%d:%d:%d: %s %.8s %.16s RAID-%s
> SSDSmartPathCap%c En%c Exp=%d\n",
> 
> So you still have an action before the identifier.  Can't you just add
> a hpsa_dev_printk macro similar to sdev_printk that encapsulates the
> format, and also makes sure it's always the prefix for the log message?
