From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: moving drivers to a new drivers/ata directory
Date: Wed, 20 Oct 2004 16:34:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041020153444.GA21881@infradead.org>
References: <416F5757.8000306@pobox.com> <20041015074627.GA18977@infradead.org> <41700747.6040506@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:16393 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268323AbUJTPex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 11:34:53 -0400
Content-Disposition: inline
In-Reply-To: <41700747.6040506@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Fri, Oct 15, 2004 at 01:22:15PM -0400, Jeff Garzik wrote:
> Welcome to the real world, where SCSI drivers can be for non-SCSI 
> hardware, and where SCSI hardware can also drive non-SCSI devices.
> 
> Fix your subsystem, if it can't support SCSI drivers outside of 
> drivers/scsi.

It's not about not working but making life for the scsi maintainers easier.

