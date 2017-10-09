From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: libiscsi: fix shifting of DID_REQUEUE host byte
Date: Mon, 9 Oct 2017 16:33:35 +0200
Message-ID: <20171009143335.l7ilixy46op5ipbx@linux-x5ow.site>
References: <20171009113319.9505-1-jthumshirn@suse.de>
 <9105c7ef-0255-520c-3c90-e52a16fa5509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9105c7ef-0255-520c-3c90-e52a16fa5509@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Chris Leech <cleech@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 09, 2017 at 02:35:06PM +0200, Steffen Maier wrote:
> Use wrapper functions to advertize their use in an attempt to avoid wrong
> shifting in the future?

After a second thought and a bit of coccinelle magic I converted all drivers
under drivers/scsi to use set_host_byte(), msg and driver byte will follow as
well.

But all this is on top of this patch, which IMHO is stable material (we had an
actual customer bug with this).

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
