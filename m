From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] fcoe: provide translation table between Ethernet and FC
 port speeds
Date: Fri, 19 Aug 2016 13:30:06 +0200
Message-ID: <20160819113006.4mbt3tnwbwn4hmmt@c203.arch.suse.de>
References: <1471274649-27113-1-git-send-email-jthumshirn@suse.de>
 <7044694b-7991-8daa-55bd-faa603c1f6f8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7044694b-7991-8daa-55bd-faa603c1f6f8@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 19, 2016 at 10:37:04AM +0200, Hannes Reinecke wrote:
> On 08/15/2016 05:24 PM, Johannes Thumshirn wrote:

[...]

> >  
> > +static const struct {
> > +	u32 fc_port_speed;
> > +	u32 eth_port_speed;
> > +} fcoe_port_speed_mapping[] = {
> > +	{ FC_PORTSPEED_1GBIT, SPEED_1000 },
> > +	{ FC_PORTSPEED_2GBIT, 2000 },
> > +	{ FC_PORTSPEED_4GBIT, 4000 },
> > +	{ FC_PORTSPEED_8GBIT, 8000 },
> > +	{ FC_PORTSPEED_10GBIT, SPEED_10000 },
> > +	{ FC_PORTSPEED_16GBIT, 16000 },
> > +	{ FC_PORTSPEED_20GBIT, SPEED_20000  },
> > +	{ FC_PORTSPEED_25GBIT, SPEED_25000  },
> > +	{ FC_PORTSPEED_32GBIT, 32000 },
> > +	{ FC_PORTSPEED_40GBIT, SPEED_40000  },
> > +	{ FC_PORTSPEED_50GBIT, SPEED_50000  },
> > +	{ FC_PORTSPEED_100GBIT, SPEED_100000 },
> > +};
> > +
> Hmm. Why not 'SPEED_2000' etc?
> 
> This looks a bit weird, mixing values with defines ...

I'll add defines for the non Ethernet native speeds privately to this file.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
