From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Sun, 16 Oct 2005 10:32:00 +0200
Message-ID: <1129451520.2911.12.camel@laptopd505.fenrus.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
	 <20051013231614.27191.9897.sendpatchset@plap.qlogic.com>
	 <20051015115654.GA24919@infradead.org>  <4351A123.9040104@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9178 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751316AbVJPIcG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 04:32:06 -0400
In-Reply-To: <4351A123.9040104@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@infradead.org>

On Sun, 2005-10-16 at 10:38 +1000, Douglas Gilbert wrote:
> Christoph Hellwig wrote:
> > On Thu, Oct 13, 2005 at 04:16:14PM -0700, Andrew Vasquez wrote:
> > 
> >>Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > 
> > 
> > NACK.  My contributions won't be relicensed under such an odd license.
> > The real fix is to allow userspace firmware loading for all HBA types
> > (as done in one of the later patches) and eventually remove the firmware
> > completely.
> 
> Andrew,
> Another approach is to separate out changes made
> by Christoph and Arjan into a separate file (or
> files) and leave the GPL on that file.

..as well as any other contributor that isn't qlogic...

to be honest I suspect there will be nothing left for that though. It
also voids the goal of this license change as far as I can see..
(and also I think that is legally iffy as well; one could argue that
half the driver is a derived work of the other half (as well as probably
a derived work of linux) and as such it needs to be GPL as well)

