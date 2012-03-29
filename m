From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v3 4/7] libata: detech Device Attention support
Date: Thu, 29 Mar 2012 13:06:34 +0800
Message-ID: <1332997594.3793.118.camel@minggr>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
	 <1332915722-15963-5-git-send-email-ming.m.lin@intel.com>
	 <4F72F45D.7090800@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4F72F45D.7090800@mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-03-28 at 15:22 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 28-03-2012 10:21, Lin Ming wrote:
> 
> > Add a new flag ATA_DFLAG_DA to indicate that device supports "Device
> > Attention".
> 
> > Acked-by: Aaron Lu<aaron.lu@amd.com>
> > Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> [...]
> 
> > diff --git a/include/linux/ata.h b/include/linux/ata.h
> > index 32df2b6..6ee41cc 100644
> > --- a/include/linux/ata.h
> > +++ b/include/linux/ata.h
> > @@ -578,6 +578,7 @@ static inline int ata_is_data(u8 prot)
> >   	  ((u64) (id)[(n) + 0]) )
> >
> >   #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG]&  0x60) == 0x20)
> > +#define atapi_id_has_da(id)	((id)[77]&  (1<<  4))
> 
>     We prefix these macros with 'ata_' despite them being applied to IDENTIFY 
> DEVICE data or IDENTIFY PAKCET DEVICE data. ata_id_cdb_intr(), for example, 
> applies only to IDENTIFY PAKCET DEVICE data.

OK, will change it.

> 
> MBR, Sergei


