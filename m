From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Mon, 21 Jun 2004 12:16:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47355 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266293AbUFUQQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 12:16:22 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

All,

We are pleased to announce the MPT Fusion release candidate for lk 2.6

This driver incorporates the patches from Christoph Hellwig, Jeremy Higdon,
and Masao Fukuchi.

Changelog of this release:
 - merged code from lk 2.4 MPT Fusion driver(from versions 2.05.13 to
2.05.16)

* Patch from Masao Fukuchi
 - Remove limit on number of support hosts 

* Patch from Christoph Hellwig
 - kill scsi_to_pci_dma_dir usage, both pci and scsi use the same bits
 - kill mptscsih_io_direction and always trust the midlayer
 - kill usage of Scsi_Foo typedefs
 - use <scsi/*.h> headers
 - avoid list search in fusion ->proc_info

* Patch from Jeremy Higdon
 - Add readX_relaxed to MPT Fusion driver

The patch for lk 2.6.6 and the driver is available at

ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.09


Eric Moore
Standard Storage Products Division
LSI Logic Corporation
