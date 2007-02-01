From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 17:35:53 +0900
Message-ID: <45C1A669.5000206@gmail.com>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca> <45C1A424.5040805@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:60488 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422681AbXBAIgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2007 03:36:14 -0500
Received: by wx-out-0506.google.com with SMTP id h31so478943wxd
        for <linux-scsi@vger.kernel.org>; Thu, 01 Feb 2007 00:36:14 -0800 (PST)
In-Reply-To: <45C1A424.5040805@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
>> For example, I think all existing ATAPI drives only speak 12-byte packet
>> protocols, and so if we tell SCSI we're good for 16-byte, then won't the
>> SCSI layer suddenly start sending us READ_16 and the like?
> 
> Speaking strictly about the device, IDENTIFY PACKET DEVICE data page
> tells us whether the device supports 12-byte or 16-byte CDBs.  No need
> to guess.
> 
> Some host controllers only support 12-byte, but I think that most should
> support 16-byte.

Out of curiosity, does ATA controllers which don't allow 16byte CDB
actually exist?  It's transferred using PIO protocol anyway.

-- 
tejun
