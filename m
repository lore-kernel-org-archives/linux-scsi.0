From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 0/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 14:43:58 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70307646@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53228 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964940AbWIKUoE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 16:44:04 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Monday, September 11, 2006 1:56 PM, Jeff Garzik wrote: 

> > A pretty print for the current u32 would be very useful though for
> > transports dealing with non single level luns (or address 
> methods other
> > than zero).
> 
> A better subject line would have been "HCIL isolation" I suppose.  I 
> would like to see increased usage of the accessors already present in 
> include/scsi/scsi_device.h, which would ease the transition from 
> hardcoded HCIL struct members to a more flexible addressing method.
> 
> Though, FWIW, for LUNs I would certainly like to see u64 rather than 
> u32.....
> 

shouldn't luns be defined as: 

u8 lun[8] instead of u64?  

Luben?
