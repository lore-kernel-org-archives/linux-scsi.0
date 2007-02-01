From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 10:15:16 -0500
Message-ID: <45C20404.7040709@garzik.org>
References: <200701021935.07840.liml@rtr.ca>	 <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com>	 <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com>	 <45C1A4BD.3030909@garzik.org> <45C1A823.30008@gmail.com>	 <45C1B8D4.1070209@garzik.org> <1170342565.3388.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1170342565.3388.4.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> But you're requesting code changes in the SCSI layer because of this
> incorrect usage.  max_cdb is supposed to be the *host* limit.  The mid
> layer finds out and respects device limits separately from this.

I never requested any such thing.

	Jeff


