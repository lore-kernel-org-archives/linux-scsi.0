From: Adam Manzanares <adam.manzanares@wdc.com>
Subject: Re: [PATCH v6 3/3] ata: ATA Command Priority Disabled By Default
Date: Wed, 19 Oct 2016 11:09:53 -0700
Message-ID: <20161019180952.GA17968@hgst.com>
References: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
 <1476728850-2309-4-git-send-email-adam.manzanares@hgst.com>
 <20161019180553.GI18532@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161019180553.GI18532@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Adam Manzanares <adam.manzanares@hgst.com>, axboe@kernel.dk, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The 10/19/2016 14:05, Tejun Heo wrote:
> On Mon, Oct 17, 2016 at 11:27:30AM -0700, Adam Manzanares wrote:
> > Add a sysfs entry to turn on priority information being passed
> > to a ATA device. By default this feature is turned off.
> > 
> > This patch depends on ata: Enabling ATA Command Priorities
> > 
> > Signed-off-by: Adam Manzanares <adam.manzanares@hgst.com>
> > ---
> >  drivers/ata/libahci.c     |  1 +
> >  drivers/ata/libata-core.c |  2 +-
> >  drivers/ata/libata-scsi.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/libata.h    |  7 +++++
> >  4 files changed, 77 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> > index 0d028ea..0e17285 100644
> > --- a/drivers/ata/libahci.c
> > +++ b/drivers/ata/libahci.c
> > @@ -140,6 +140,7 @@ EXPORT_SYMBOL_GPL(ahci_shost_attrs);
> >  struct device_attribute *ahci_sdev_attrs[] = {
> >  	&dev_attr_sw_activity,
> >  	&dev_attr_unload_heads,
> > +	&dev_attr_ncq_prio_on,
> 
> I'll rename it to ncq_prio_enable while applying but otherwise looks
> good to me.

Sounds good.

Take care,
Adam

> 
> Thanks.
> 
> -- 
> tejun
