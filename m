From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] aacraid: better sysfs adapter information
Date: Thu, 1 Dec 2005 17:55:45 +0000
Message-ID: <20051201175545.GB13470@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E146@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46251 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932376AbVLARzs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 12:55:48 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E146@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Nov 30, 2005 at 02:35:41PM -0500, Salyzyn, Mark wrote:
> Christoph Hellwig [mailto:hch@infradead.org] writes:
> > > Provide more accurate adapter information.
> > so what information is this going to print now? do you have 
> > an example?
> 
> This change empowers the Firmware.
> 
> This allows the Adapter Firmware to override the Adapter product
> information. The information before this modification was table driven
> by the PCI Product ID.
> 
> In some cases the change is merely for OEMization (IBM 8i or ADAPTEC
> 4005SAS), in other cases we have the 'family' match that permits the
> driver to attach to all future adapters, and without this change the
> Adapter would be designated the mundane name of "ADAPTEC RAID" rather
> than the name that the Firmware reports.

Ok, makes sense.  Can we now get rid of the huge table of product names
in linit.c?

