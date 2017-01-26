From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 2/4] mpt3sas: Fix for Crusader to achieve product
 targets with SAS devices.
Date: Thu, 26 Jan 2017 09:23:10 +0100
Message-ID: <20170126082310.GA3591@linux-x5ow.site>
References: <1485165370-43401-1-git-send-email-chaitra.basappa@broadcom.com>
 <1485165370-43401-3-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485165370-43401-3-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 23, 2017 at 03:26:08PM +0530, Chaitra P B wrote:
> Small glitch/degraded performance in Crusader is improved with SAS
> drives by removing unnecessary spinlocks while clearing scsi command
> in drivers internal lookup table.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---


Sorry for misreading the patch, it's exactly what I've requestd.

Therefore:
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
