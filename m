From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: 2.5.56-mm1 fails to detect cd burner
Date: Tue, 18 Mar 2003 13:13:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030318211357.GA1232@holomorphy.com>
References: <20030311063627.GJ1399@holomorphy.com> <20030311160358.GN465@holomorphy.com> <3196100000.1047914843@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3196100000.1047914843@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Mar 10, 2003 at 10:36:27PM -0800, William Lee Irwin III wrote:
>> jejb referred me to you (gibbs) for this after guiding me through a
>> cable check.

On Mon, Mar 17, 2003 at 08:27:23AM -0700, Justin T. Gibbs wrote:
> Can you try the latest driver 6.2.30, from here:
> http://people.FreeBSD.org/~gibbs/linux/SRC/
> Just untar the 2.5.X tarball into your source tree and recompile.
> If you still are having problems with the driver at that point, I'll
> guide you through other steps to enable debugging and get additional
> information.

Okay, I've got 2.5.65-mm1 up and it's detected. It needs some runtime
testing I'll have to do in 12-36 hours, probably with virgin 2.5.65
plus your driver.

Thanks.

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.28
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

anticipatory scheduling elevator
(scsi0:A:0): 40.000MB/s transfers (20.000MHz, offset 31, 16bit)
  Vendor: WDIGTL    Model: WDE18310 ULTRA2   Rev: 1.30
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
anticipatory scheduling elevator
(scsi0:A:3): 20.000MB/s transfers (20.000MHz, offset 15)
  Vendor: YAMAHA    Model: CRW8424S          Rev: 1.0j
  Type:   CD-ROM                             ANSI SCSI revision: 02
anticipatory scheduling elevator
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.28
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

anticipatory scheduling elevator
(scsi1:A:6): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
  Vendor: IBM       Model: DDYS-T36950N      Rev: S93E
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:6:0: Tagged Queuing enabled.  Depth 253
anticipatory scheduling elevator
st: Version 20021214, fixed bufsize 32768, wrt 30720, s/g segs 256
SCSI device sda: 35761710 512-byte hdwr sectors (18310 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 71687340 512-byte hdwr sectors (36704 MB)
SCSI device sdb: drive cache: write through
 sdb: unknown partition table
Attached scsi disk sdb at scsi1, channel 0, id 6, lun 0
sr0: scsi3-mmc drive: 24x/16x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.12
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 3, lun 0

-- wli
