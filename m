From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 8 Jan 2016 05:01:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39FA6C38@ORSMSX114.amr.corp.intel.com>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
 <yq137u8iyue.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59951 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbcAHFBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 00:01:17 -0500
In-Reply-To: <yq137u8iyue.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Martin,

Thanks for looking at this.

> megaraid_sas is an entirely different beast from mpt[23]sas. Please let
> us know which type of controller your disks are hanging off of.

Can you tell from the "mpt" messages in the console log?  Here's
output of "dmesg | grep mpt" from a v4.3 boot:

[   17.021171] mpt2sas version 20.100.00.00 loaded
[   17.108039] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (528247880 kB)
[   17.441605] mpt2sas0: MSI-X vectors supported: 8, no of cores: 192, max_msix_vectors: 8
[   17.443653] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 42
[   17.443654] mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 43
[   17.443655] mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 44
[   17.443655] mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 45
[   17.443656] mpt2sas0-msix4: PCI-MSI-X enabled: IRQ 46
[   17.443656] mpt2sas0-msix5: PCI-MSI-X enabled: IRQ 47
[   17.443657] mpt2sas0-msix6: PCI-MSI-X enabled: IRQ 48
[   17.443657] mpt2sas0-msix7: PCI-MSI-X enabled: IRQ 49
[   17.443659] mpt2sas0: iomem(0x0000000093340000), mapped(0xffffc90032b80000), size(65536)
[   17.443660] mpt2sas0: ioport(0x0000000000001000), size(256)
[   17.897167] mpt2sas0: Allocated physical memory: size(6712 kB)
[   17.897168] mpt2sas0: Current Controller Queue Depth(2811), Max Controller Queue Depth(3072)
[   17.897169] mpt2sas0: Scatter Gather Elements per IO(128)
[   18.129978] mpt2sas0: LSISAS2308: FWVersion(17.00.01.00), ChipRevision(0x05), BiosVersion(07.24.01.00)
[   18.129985] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Tas
k Set Full,NCQ)
[   18.131619] mpt2sas0: sending port enable !!
[   19.662657] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b006c4ed70), phys(8)
[   25.796718] mpt2sas0: port enable: SUCCESS
[   28.565856] mptctl: Registered with Fusion MPT base driver
[   28.565857] mptctl: /dev/mptctl @ (major,minor=10,220)

If you need something more, let me know what commands to run.

-Tony
