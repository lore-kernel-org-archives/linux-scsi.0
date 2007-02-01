From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 04:54:28 -0500
Message-ID: <45C1B8D4.1070209@garzik.org>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com> <45C1A4BD.3030909@garzik.org> <45C1A823.30008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C1A823.30008@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Well, it's not any worse than what we're currently doing.  We don't set

Agreed... but that doesn't make it the /right/ thing to do ;-)

The logic behind the current code, which limits to the maximum size 
allowed by an attached device on the port, is mainly to leverage the 
SCSI layer as a filter for bad CDB lengths.

IOW, it's called "being lazy" ;-)

	Jeff


