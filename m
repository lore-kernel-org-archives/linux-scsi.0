From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 03:26:12 -0500
Message-ID: <45C1A424.5040805@garzik.org>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C1377F.6070001@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> For example, I think all existing ATAPI drives only speak 12-byte packet
> protocols, and so if we tell SCSI we're good for 16-byte, then won't the
> SCSI layer suddenly start sending us READ_16 and the like?


Speaking strictly about the device, IDENTIFY PACKET DEVICE data page 
tells us whether the device supports 12-byte or 16-byte CDBs.  No need 
to guess.

Some host controllers only support 12-byte, but I think that most should 
support 16-byte.

	Jeff


