From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
Date: Tue, 14 Aug 2007 10:17:26 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709166CA@NAMAIL4.ad.lsil.com>
References: <20070814103330.GA9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60216 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbXHNQRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 12:17:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070814103330.GA9944@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Tuesday, August 14, 2007 4:34 AM,  Prakash, Sathya wrote:
> Add support for ATTO UL4D, they are rebranded 53C1030. 
> The changes are
> 1. Adding a new PCI vendor ID in pci table 
> 2. The spi_port_page_2 is in different format than that of 
> LSI generic 
> spi_port_page_2 and hence mapping code is added.
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>


ACK
