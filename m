From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 20:36:52 -0800
Message-ID: <499B9064.4060504@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B807B.2050509@kernel.org> <alpine.DEB.1.10.0902171935110.26625@asgard.lang.hm> <
 499B84CE.7090707@kernel.org> <alpine.DEB.1.10.0902172013230.26625@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZBREhg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 23:37:36 -0500
In-Reply-To: <alpine.DEB.1.10.0902172013230.26625@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

david@lang.hm wrote:
> On Tue, 17 Feb 2009, Yinghai Lu wrote:
> 
>> please try two patches at the same time on 2.6.29-rc5.
>> don't apply other patch.
> 
> I did a git checkout -f HEAD then applied these two patches and the
> result works.
> 

good. MSI does work on your system now.

mptsas 0000:82:03.0: PCI INT A -> GSI 75 (level, low) -> IRQ 75

mptbase: ioc0: Initiating bringup

ioc0: LSISAS1068 B1: Capabilities={Initiator}

mptsas 0000:82:03.0: irq 92 for MSI/MSI-X

mptbase: ioc0: PCI-MSI enabled

scsi8 : ioc0: LSISAS1068 B1, FwRev=01120000h, Ports=1, MaxQ=511, IRQ=92

scsi 8:0:0:0: Direct-Access     SEAGATE  ST3146855SS      RS02 PQ: 0 ANSI: 5

scsi 8:0:0:0: Attached scsi generic sg1 type 0

scsi 8:0:1:0: Direct-Access     SEAGATE  ST3146855SS      RS02 PQ: 0 ANSI: 5

scsi 8:0:1:0: Attached scsi generic sg2 type 0

scsi 8:1:0:0: Direct-Access     LSILOGIC Logical Volume   3000 PQ: 0 ANSI: 2

sd 8:1:0:0: [sda] 285155328 512-byte hardware sectors: (145 GB/135 GiB)

sd 8:1:0:0: [sda] Write Protect is off

sd 8:1:0:0: [sda] Mode Sense: 03 00 00 08

sd 8:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

sd 8:1:0:0: [sda] 285155328 512-byte hardware sectors: (145 GB/135 GiB)

sd 8:1:0:0: [sda] Write Protect is off

sd 8:1:0:0: [sda] Mode Sense: 03 00 00 08

sd 8:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

 sda: sda1 sda2 sda3 sda4

sd 8:1:0:0: [sda] Attached SCSI disk

sd 8:1:0:0: Attached scsi generic sg3 type 0

YH




