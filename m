From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: Re: caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 22:17:01 +0200
Message-ID: <20110330201700.GA6775@apartia.fr>
References: <20110330080114.GA5066@apartia.fr>
 <4565AEA676113A449269C2F3A549520F8086471A@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:50862 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab1C3URG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 16:17:06 -0400
Content-Disposition: inline
In-Reply-To: <4565AEA676113A449269C2F3A549520F8086471A@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org

On Wed, Mar 30, 2011 at 02:02:12PM -0600, Moore, Eric wrote:
> Hi Louis, can you send me your /var/log/messages and dmesg output?
> Please capture after you've run your test.

Hi,

My test produces no specific output through dmesg or /var/log/messages
as there is no apparent error from the controller.

However I can send you the syslog startup output. Let me know if I can
run any further tests or provide more information.

Thanks,

Mar 28 08:19:40 zenon kernel: mpt2sas 0000:02:00.0: PCI INT A -> GSI 41 (level, low) -> IRQ 41
Mar 28 08:19:40 zenon kernel: mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (16423628 kB)
Mar 28 08:19:40 zenon kernel: mpt2sas0: IO-APIC enabled: IRQ 41
Mar 28 08:19:40 zenon kernel: mpt2sas0: iomem(0x00000000df2b0000), mapped(0xffffc90000040000), size(65536)
Mar 28 08:19:40 zenon kernel: mpt2sas0: ioport(0x000000000000fc00), size(256)
Mar 28 08:19:40 zenon kernel: mpt2sas0: sending diag reset !!
Mar 28 08:19:40 zenon kernel: mpt2sas0: diag reset: SUCCESS
Mar 28 08:19:40 zenon kernel: mpt2sas0: Allocated physical memory: size(3971 kB)
Mar 28 08:19:40 zenon kernel: mpt2sas0: Current Controller Queue Depth(1739), Max Controller Queue Depth(2000)
Mar 28 08:19:40 zenon kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Mar 28 08:19:40 zenon kernel: mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x02), BiosVersion(07.17.00.00)
Mar 28 08:19:40 zenon kernel: mpt2sas0: Dell PERC H200 Integrated: Vendor(0x1000), Device(0x0072), SSVID(0x1028), SSDID(0x1F1E)
Mar 28 08:19:40 zenon kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
Mar 28 08:19:40 zenon kernel: mpt2sas0: sending port enable !!
Mar 28 08:19:40 zenon kernel: mpt2sas0: host_add: handle(0x0001), sas_addr(0x5842b2b05020c600), phys(8)
Mar 28 08:19:40 zenon kernel: mpt2sas0: port enable: SUCCESS
Mar 28 08:19:40 zenon kernel: scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221103000000), phy(3), device_name(0x4ee25001f42e5a40)
Mar 28 08:19:40 zenon kernel: scsi 0:0:0:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(0)
Mar 28 08:19:40 zenon kernel: scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:1:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221102000000), phy(2), device_name(0x4ee25001be5f04eb)
Mar 28 08:19:40 zenon kernel: scsi 0:0:1:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:2:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221101000000), phy(1), device_name(0x4ee250019791af96)
Mar 28 08:19:40 zenon kernel: scsi 0:0:2:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(2)
Mar 28 08:19:40 zenon kernel: scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:3:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221100000000), phy(0), device_name(0x4ee25001beeb04eb)
Mar 28 08:19:40 zenon kernel: scsi 0:0:3:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(3)
Mar 28 08:19:40 zenon kernel: scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:4:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x4ee25001d9b104eb)
Mar 28 08:19:40 zenon kernel: scsi 0:0:4:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(7)
Mar 28 08:19:40 zenon kernel: scsi 0:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:4:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:5:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221107000000), phy(7), device_name(0x4ee25001c38204eb)
Mar 28 08:19:40 zenon kernel: scsi 0:0:5:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(4)
Mar 28 08:19:40 zenon kernel: scsi 0:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:5:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:6:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221106000000), phy(6), device_name(0x4ee250019a1baf96)
Mar 28 08:19:40 zenon kernel: scsi 0:0:6:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(5)
Mar 28 08:19:40 zenon kernel: scsi 0:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:6:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: scsi 0:0:7:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Mar 28 08:19:40 zenon kernel: scsi 0:0:7:0: SATA: handle(0x0010), sas_addr(0x4433221105000000), phy(5), device_name(0x4ee2500136d4af96)
Mar 28 08:19:40 zenon kernel: scsi 0:0:7:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(6)
Mar 28 08:19:40 zenon kernel: scsi 0:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Mar 28 08:19:40 zenon kernel: scsi 0:0:7:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
Mar 28 08:19:40 zenon kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar 28 08:19:40 zenon kernel: sd 0:0:1:0: Attached scsi generic sg1 type 0
Mar 28 08:19:40 zenon kernel: sd 0:0:2:0: Attached scsi generic sg2 type 0
Mar 28 08:19:40 zenon kernel: sd 0:0:3:0: Attached scsi generic sg3 type 0
Mar 28 08:19:40 zenon kernel: sd 0:0:4:0: Attached scsi generic sg4 type 0
Mar 28 08:19:40 zenon kernel: sd 0:0:5:0: Attached scsi generic sg5 type 0
Mar 28 08:19:40 zenon kernel: sd 0:0:6:0: Attached scsi generic sg6 type 0
Mar 28 08:19:40 zenon kernel: sd 0:0:7:0: Attached scsi generic sg7 type 0
Mar 28 08:19:40 zenon kernel: ata_piix 0000:00:1f.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
Mar 28 08:19:40 zenon kernel: ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
Mar 28 08:19:40 zenon kernel: sd 0:0:6:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:5:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:2:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:1:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:3:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:4:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:7:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Mar 28 08:19:40 zenon kernel: sd 0:0:6:0: [sdg] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:5:0: [sdf] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:0:0: [sda] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:2:0: [sdc] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:6:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sd 0:0:5:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sd 0:0:4:0: [sde] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:3:0: [sdd] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:1:0: [sdb] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:7:0: [sdh] Write Protect is off
Mar 28 08:19:40 zenon kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sd 0:0:7:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sd 0:0:4:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 28 08:19:40 zenon kernel: sdg: sdg1 sdg2 sdg3
Mar 28 08:19:40 zenon kernel: sdf: sdf1 sdf2 sdf3
Mar 28 08:19:40 zenon kernel: sdc: sdc1 sdc2 sdc3
Mar 28 08:19:40 zenon kernel: sde: sde1 sde2 sde3
Mar 28 08:19:40 zenon kernel: sda: sda1 sda2 sda3
Mar 28 08:19:40 zenon kernel: sdb: sdb1 sdb2 sdb3
Mar 28 08:19:40 zenon kernel: sdd: sdd1 sdd2 sdd3
Mar 28 08:19:40 zenon kernel: sdh: sdh1 sdh2 sdh3


> Eric Moore
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Louis-David Mitterrand
> > Sent: Wednesday, March 30, 2011 2:01 AM
> > To: linux-scsi@vger.kernel.org
> > Subject: caviar black + mpt2sas horrific performance
> > 
> > Hi,
> > 
> > I am seeing horrific performance on a Dell T610 with a LSISAS2008 (Dell
> > H200) card and 8 WD1002FAEX Caviar Black 1TB configured in mdadm raid6.
> > 
> > The LSI card is upgraded to the latest 9.00 firmware:
> > http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/in
> > ternal/sas9211-8i/index.html
> > and the 2.6.38.2 kernel uses the newer mpt2sas driver.
> > 
> > On the T610 this command takes 20 minutes:
> > 
> > 	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  22.64s user 3.34s system 2%
> > cpu 20:00.69 total
> > 
> > where on a lower spec'ed Poweredge 2900 III server (LSI Logic MegaRAID
> > SAS 1078 + 8 x Hitachi Ultrastar 7K1000 in mdadm raid6) it takes 22
> > _seconds_:
> > 
> > 	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  16.40s user 3.22s system 86%
> > cpu 22.773 total
> > 
> > Besides hardware, the other difference between servers is that the
> > PE2900's MegaRAID has no JBOD mode so each disk must be configured as a
> > "raid0" vdisk unit. On the T610 no configuration was necessary for the
> > disks to "appear" in the OS. Would configuring them as raid0 vdisks
> > change anything?
> > 
> > Thanks in advance for any suggestion,
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
