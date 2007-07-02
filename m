From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] scsi disk help file is not complete
Date: Mon, 02 Jul 2007 10:14:13 -0400
Message-ID: <46890835.2050104@garzik.org>
References: <466D9440.3080005@kpnplanet.nl> <20070611115934.9097fb04.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51848 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXGBOOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jul 2007 10:14:16 -0400
In-Reply-To: <20070611115934.9097fb04.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: api <linuxgent@kpnplanet.nl>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>

Randy Dunlap wrote:
> On Mon, 11 Jun 2007 20:28:16 +0200 api wrote:
> 
>> Good day,
>> When doing make menuconfig one comes across CONFIG_BLK_DEV_SD.
>> The help file states that this is for scsi disks.NO MENTION IS MADE THAT
>> IT IS NEEDE FOR SATA DISKS AS WELL!
>> Would have saved me a lot of time if the help was up to date.
>> I hope this can be changed so others can make a kernel for sata systems
>> quicker.
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add help info for BLK_DEV_SD referring to its use in
> SATA or PATA driver configurations.
> 
> Add help text for "ATA" indicating that it probably needs
> some SCSI config symbols enabled in order to be useful.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/ata/Kconfig  |    5 +++++
>  drivers/scsi/Kconfig |    1 +
>  2 files changed, 6 insertions(+)

applied


