From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Wed, 15 Sep 2004 00:30:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915043029.GA30914@havoc.gtf.org>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com> <4147C38C.3000104@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [69.28.190.101] ([69.28.190.101]:55428 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S267440AbUIOEag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 00:30:36 -0400
Content-Disposition: inline
In-Reply-To: <4147C38C.3000104@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org

On Wed, Sep 15, 2004 at 02:22:36PM +1000, Douglas Gilbert wrote:
> I assume that OS-based ATA->SCSI translation is also out of
> the question.


In order to keep compatibility with existing libata users after libata
becomes a block driver, the ATA->SCSI translation will live on as a
completely separate, independent, optional kernel module.

If we are really lucky we can use it as a library for some of the other
drivers that do some amount of ATA->SCSI translation, or ide-scsi...

	Jeff



