From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: legacy megaraid driver bug in mm-series
Date: Thu, 8 Sep 2005 15:26:55 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662B20@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964948AbVIHT1K@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Byer <ojbyer@usa.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Thursday, September 08, 2005 3:01 PM, Ju, Seokmann wrote:
> I've tried and it works fine.
> I'm not sure where the problem is related to compilation.
> Please provide more details.
My applogize to all for confusion.

There is an issue on compiling legacy megaraid driver on 2.6.12-mm1 kernel.
That is due to undefined symbol "adapter_t *" in the megaraid_reset().
I'm not sure how and where this change came from, though.

I'll create patch and submit soon.

Thank you.

> -----Original Message-----
> From: Ju, Seokmann [mailto:sju@lsil.com] 
> Sent: Thursday, September 08, 2005 3:01 PM
> To: Jack Byer; linux-kernel@vger.kernel.org
> Subject: RE: legacy megaraid driver bug in mm-series
> 
> Hi,
> 
> On Monday, September 05, 2005 9:06 PM, Jack Byer wrote:
> > 2.6.12-mm1:	will not compile megaraid driver
> I've tried and it works fine.
> I'm not sure where the problem is related to compilation.
> Please provide more details.
> 
> Thank you,
> 
> Seokmann
> 
> > -----Original Message-----
> > From: Jack Byer [mailto:ojbyer@usa.net] 
> > Sent: Monday, September 05, 2005 9:06 PM
> > To: linux-kernel@vger.kernel.org
> > Subject: legacy megaraid driver bug in mm-series
> > 
> > My AMI megaraid card no longer works with recent mm-series 
> > kernels. The
> > bug appears on mm- kernels newer than 2.6.12-rc6-mm1; 
> mainline kernels
> > are not affected.
> > 
> > The driver will load and detect both devices on the card (sda 
> > and sdb).
> > It will scan each device and read the partition table successfully,
> > however the megaraid driver message will include the 
> following errors:
> > 
> > sda: sector size 0 reported, assuming 512.
> > sda: asking for cache data failed.
> > sda: assuming drive cache: write through
> > 
> > When the kernel tries to mount the root file system, I get 
> > the following
> > error:
> > 
> > ReiserFS: sda3: warning: sh-2006: read_super_block: bread 
> failed (dev
> > sda3, block 2, size 4096)
> > ReiserFS: sda3: warning: sh-2006: read_super_block: bread 
> failed (dev
> > sda3, block 16, size 4096)
> > VFS: Cannot open root device "sda3" or unknown-block(0,3)
> > 
> > Here is a summary of the kernels I have tested for this bug:
> > 
> > 2.6.11-mm1:	works
> > 2.6.11-mm4:	works
> > 2.6.12-rc5-mm1:	will not compile
> > 2.6.12-rc6-mm1:	works
> > 2.6.12-mm1:	will not compile megaraid driver
> > 2.6.12-mm2:	broken
> > 2.6.13-mm1:	broken
> > 
> > 2.6.12:		works
> > 2.6.13:		works
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
