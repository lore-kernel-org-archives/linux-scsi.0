From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/4] fusion - sas support
Date: Wed, 1 Jun 2005 14:21:17 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C028C616C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44161 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261164AbVFAUV2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 16:21:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux scsi <linux-scsi@vger.kernel.org>

> On Wed, 2005-06-01 at 10:47 -0600, Moore, Eric Dean wrote:
> > Changelog:
> > * adding support for new module in Kconfig and Makefile
> > * adding mptsas.c module 
> 
> No to this one until you and Adaptec (and any other 
> interested parties)
> get the sas transport class sorted out and in use ... at least in
> embryo.  I won't hold the drivers up while the fine details and code
> location is sorted out, but we need to get at least the structure in
> place.
> 

All this patch does is add SAS PCI reorganization support.  
So our customers can install Linux onto SAS part.  I'm not
adding application support for new ioctls, so it make no sense
to kill SAS for many people over your stance on the transport class. 
And by the way, Luben Tuikov(Adaptec) has posted an RFC on sas
transport class back in April, and it seems its progress was 
all by killed by Christoph.  What can we do get this moving??


> Additionally:
> 
> 
> > +static struct device_attribute mptsas_queue_depth_attr = {
> > +       .attr = {
> > +               .name =         "queue_depth",
> > +               .mode =         S_IWUSR,
> > +       },
> > +       .store = mptscsih_store_queue_depth,
> > +};
> 
> This can all be done with the change_queue_depth host template API.
> 

Fine, I will look into it.  It appears to be implemented in 3w-9xxx and ipr
drivers.


> There are also a suspicious lot of SPI strings in the SAS driver (are
> these cut and paste issues?):
> 

I goofed. Thanks for seeing that.


Eric Moore
LSI Logic
