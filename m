From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sr: Avoid that opening a CD-ROM hangs with runtime power
 management enabled
Date: Fri, 3 Aug 2018 10:48:16 +0200
Message-ID: <20180803084816.4irdl2lduwgfsupf@linux-x5ow.site>
References: <20180802174442.7310-1-bart.vanassche@wdc.com>
 <20180803082845.nntzwgny6fprg54r@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180803082845.nntzwgny6fprg54r@linux-x5ow.site>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 03, 2018 at 10:28:45AM +0200, Johannes Thumshirn wrote:
> On Thu, Aug 02, 2018 at 10:44:42AM -0700, Bart Van Assche wrote:
> > Surround scsi_execute() calls with scsi_autopm_get_device() and
> > scsi_autopm_put_device(). Note: removing sr_mutex protection from
> > the scsi_cd_get() and scsi_cd_put() calls is safe because the
> > purpose of sr_mutex is to serialize cdrom_*() calls.
> > 
> [...]
> 
> Hi Bart,
> 
> With this patch I still have the hang on next-20180801:

Forget my last email, I didn't have Ming's 'blk-mq: fix
blk_mq_tagset_busy_iter' applied.

Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
