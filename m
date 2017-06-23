From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: aacraid: Don't copy uninitialized stack memory to
 userspace
Date: Fri, 23 Jun 2017 16:11:46 +0200
Message-ID: <20170623141145.GF13014@linux-x5ow.site>
References: <20170623140422.30320-1-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170623140422.30320-1-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 23, 2017 at 09:04:22AM -0500, Seth Forshee wrote:
> Both aac_send_raw_srb() and aac_get_hba_info() may copy stack
> allocated structs to userspace without initializing all members
> of these structs. Clear out this memory to prevent information
> leaks.
> 
> Fixes: 423400e64d377 ("scsi: aacraid: Include HBA direct interface")
> Fixes: c799d519bf088 ("scsi: aacraid: Retrieve HBA host information ioctl")
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
