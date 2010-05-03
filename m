From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme for scsi device(This is correct revision, please ignore last one)
Date: Mon, 3 May 2010 21:11:24 +0800
Message-ID: <4FF3529D44A744779DF0EA4F2A39941F@areca4e4f859d4>
References: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4> <1272891585.4369.15.camel@mulgrave.site>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35346 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab0ECNLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2010 09:11:37 -0400
In-Reply-To: <1272891585.4369.15.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Do you compile the code after applying all of three patches?
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Monday, May 03, 2010 9:00 PM
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
for scsi device(This is correct revision, please ignore last one)

On Mon, 2010-05-03 at 15:45 +0800, Nick Cheng wrote:
> 1. To support instantaneous report for SCSI device existing by periodic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus reset
> 4. To support HW reset in bus reset error handler
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

This patch still isn't compiling:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_pci_slot_reset':
drivers/scsi/arcmsr/arcmsr_hba.c:2733: error: too few arguments to
function 'arcmsr_get_firmware_spec'
make[1]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1
make: *** [drivers/scsi/arcmsr/arcmsr.ko] Error 2

It looks like you missed converting one of the
arcmsr_get_firmware_spec() to the two argument prototype.

James


