From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 4/7] mpt2sas: setting SDEV into RUNNING state from
 Interrupt context
Date: Fri, 14 Aug 2009 09:41:52 -0600
Message-ID: <660360F4F2570145BD872F298951B17AB2C2F52E@cosmail03.lsi.com>
References: <1250262669.4021.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:56134 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZHNPmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 11:42:03 -0400
In-Reply-To: <1250262669.4021.11.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Friday, August 14, 2009 9:11 AM,  James Bottomley wrote: 
> 
> OK, so explain these functions _scsih_ublock_io_device and
> _scsih_block_io_device to me.  You're wrongly tampering with device
> state in them ... it should be using the block/unblock functions in
> scsi_lib.c if it's a standard usage.  If not, it shouldn't be touching
> the device state, especially SDEV_BLOCK, because that has 
> queue running
> and plugging implications.
> 

This is for failover/fail back.  I overlooked using scsi_device_set_state,  I assume that is what your refering to.  I guess I had been looking at old fc transport code.

Eric  