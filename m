From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mpt fusion: add support for Brocade branded LSI FC HBA
Date: Tue, 17 Jul 2007 10:55:08 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70884647@NAMAIL4.ad.lsil.com>
References: <20070717084840.GA8143@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60680 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbXGQQzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 12:55:12 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070717084840.GA8143@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, "Hickerson, Roger" <Roger.Hickerson@lsi.com>, ggrignou@brocade.com

On  Tuesday, July 17, 2007 2:49 AM,  Prakash, Sathya wrote:
> 
> Resubmitting with Eric Moore suggested modifications:
> ---
> Add support for Brocade 410/420 4Gbit FC HBAs. 
> They are re-branded LSI HBAs [LSI7104EP-LC/LSI7204EP-LC]
> 
> This patch should be applied over the following patches:
> 1. mpt fusion: deregister from transport layer if PCI 
> registration failed 
> 2. mpt fusion: add sysfs attributes to display IOC parameters 
> 3. add PCI_VENDOR_ID macro for Brocade in pci_ids.h
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> ---

ACK

Eric Moore
