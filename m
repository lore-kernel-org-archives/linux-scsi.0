From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 12:23:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41471AEA.40204@pobox.com>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42212 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269567AbUINQX1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 12:23:27 -0400
In-Reply-To: <41471A84.4090200@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Jeff Garzik wrote:
> Linus vetoed future SCSI->ATA translators.  He only allowed libata 
> because I promised to remove the translation and make it a native block 
> driver in the future, which I have been working towards.


This is why the Promise SX8 driver is a block driver, for example...

	Jeff


