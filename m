From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] ahci: Add support for Promise PDC42819
Date: Mon, 27 Oct 2008 23:57:32 -0400
Message-ID: <49068DAC.605@garzik.org>
References: <65a6ef750810222008o139600e3o8d7c7cf50a4e4ea0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54340 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbYJ1D5h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2008 23:57:37 -0400
In-Reply-To: <65a6ef750810222008o139600e3o8d7c7cf50a4e4ea0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Nelson <mdnelson8@gmail.com>
Cc: linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mikpe@it.uu.se, linux-scsi@vger.kernel.org

Mark Nelson wrote:
> Add an appropriate entry for the Promise PDC42819 controller. It has an
> AHCI mode and so far works correctly with board_ahci.
> 
> This chip is found on Promise's FastTrak TX2650 (2 port) and TX4650 (4 port)
> software-based RAID cards (for which there is a binary driver, t3sas) and
> can be found on some motherboards, for example the MSI K9A2 Platinum,
> which calls the chip a Promise T3 controller.
> 
> Although this controller also supports SAS devices, its default bootup mode
> is AHCI and the binary driver has to do some magic to get the chip into the
> appropriate mode to drive SAS disks.
> 
> Seeing as no documentation is provided by Promise, adding this entry to the
> ahci driver allows the controller to be useful to people as a SATA
> controller (with no ill effects on the system if a SAS disk is connected -
> probing of the port just times out with "link online but device
> misclassified"), without having to resort to using the binary driver. Users
> who require SAS or the proprietary software raid can get this functionality
> using the binary driver.
> 
> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
> ---
>  drivers/ata/ahci.c |    3 +++
>  1 file changed, 3 insertions(+)

applied


