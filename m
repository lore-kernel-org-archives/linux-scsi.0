From: Mark Haverkamp <markh@osdl.org>
Subject: Re: SCSI enclosure black list
Date: 14 Nov 2002 07:50:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037289000.30355.6.camel@markh1.pdx.osdl.net>
References: <1037225713.16638.85.camel@dell_ss3.pdx.osdl.net>
	 <1037227816.11996.203.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1037227816.11996.203.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Hemminger <shemminger@osdl.org>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org

On Wed, 2002-11-13 at 14:50, Alan Cox wrote:
> On Wed, 2002-11-13 at 22:15, Stephen Hemminger wrote:
> > > Thanks to Matt Domsch and Mark Haverkamp. Don't give up the good work
> > > the megaraid driver still needs better error handling.
> > 
> > The HP disk enclosures have the same behavior so use this patch instead:
> 
> Do they do the same with other drivers with known good error handling ?
> 

I wasn't sure which controllers had known good error handling, but I
tried an Adaptec AIC-7896U2/7897U2 with the IBM enclosure and got no
module panic or hang.

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.4
        <Adaptec aic7896/97 Ultra2 SCSI adapter>
        aic7896/97: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:1): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:2): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:3): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:4): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:5): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:6): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:8): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:9): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:10): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:11): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:12): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:13): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
(scsi0:A:14): 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
  Vendor: IBM-ESXS  Model: ST336605LC    !#  Rev: B243
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: IBM       Model: EXP300   S160     Rev: D014
  Type:   Processor                          ANSI SCSI revision: 03
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sda: unknown partition table
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
scsi0:A:1:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdb: unknown partition table
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
scsi0:A:2:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdc: unknown partition table
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
scsi0:A:3:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdd: unknown partition table
Attached scsi disk sdd at scsi0, channel 0, id 3, lun 0
scsi0:A:4:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sde: unknown partition table
Attached scsi disk sde at scsi0, channel 0, id 4, lun 0
scsi0:A:5:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdf: unknown partition table
Attached scsi disk sdf at scsi0, channel 0, id 5, lun 0
scsi0:A:6:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdg: unknown partition table
Attached scsi disk sdg at scsi0, channel 0, id 6, lun 0
scsi0:A:8:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdh: unknown partition table
Attached scsi disk sdh at scsi0, channel 0, id 8, lun 0
scsi0:A:9:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdi: unknown partition table
Attached scsi disk sdi at scsi0, channel 0, id 9, lun 0
scsi0:A:10:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdj: unknown partition table
Attached scsi disk sdj at scsi0, channel 0, id 10, lun 0
scsi0:A:11:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdk: unknown partition table
Attached scsi disk sdk at scsi0, channel 0, id 11, lun 0
scsi0:A:12:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdl: unknown partition table
Attached scsi disk sdl at scsi0, channel 0, id 12, lun 0
scsi0:A:13:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdm: unknown partition table
Attached scsi disk sdm at scsi0, channel 0, id 13, lun 0
scsi0:A:14:0: Tagged Queuing enabled.  Depth 253
SCSI device : drive cache: write through
SCSI device : 71096640 512-byte hdwr sectors (36401 MB)
 sdn: unknown partition table
Attached scsi disk sdn at scsi0, channel 0, id 14, lun 0
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.4
        <Adaptec aic7896/97 Ultra2 SCSI adapter>
        aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs

scsi : 0 hosts left.


-- 
Mark Haverkamp <markh@osdl.org>

