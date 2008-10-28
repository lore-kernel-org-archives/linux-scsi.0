From: "Mark Nelson" <mdnelson8@gmail.com>
Subject: Re: [PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 28 Oct 2008 16:55:39 +1100
Message-ID: <65a6ef750810272255n4a082c8ep8e305e9e3bd8fc18@mail.gmail.com>
References: <65a6ef750810222008o139600e3o8d7c7cf50a4e4ea0@mail.gmail.com>
	 <49068DAC.605@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:44294 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbYJ1Fzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 01:55:40 -0400
In-Reply-To: <49068DAC.605@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mikpe@it.uu.se, linux-scsi@vger.kernel.org

On Tue, Oct 28, 2008 at 2:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Mark Nelson wrote:
>>
>> Add an appropriate entry for the Promise PDC42819 controller. It has an
>> AHCI mode and so far works correctly with board_ahci.
>>
>> This chip is found on Promise's FastTrak TX2650 (2 port) and TX4650 (4
>> port)
>> software-based RAID cards (for which there is a binary driver, t3sas) and
>> can be found on some motherboards, for example the MSI K9A2 Platinum,
>> which calls the chip a Promise T3 controller.
>>
>> Although this controller also supports SAS devices, its default bootup
>> mode
>> is AHCI and the binary driver has to do some magic to get the chip into
>> the
>> appropriate mode to drive SAS disks.
>>
>> Seeing as no documentation is provided by Promise, adding this entry to
>> the
>> ahci driver allows the controller to be useful to people as a SATA
>> controller (with no ill effects on the system if a SAS disk is connected -
>> probing of the port just times out with "link online but device
>> misclassified"), without having to resort to using the binary driver.
>> Users
>> who require SAS or the proprietary software raid can get this
>> functionality
>> using the binary driver.
>>
>> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
>> ---
>>  drivers/ata/ahci.c |    3 +++
>>  1 file changed, 3 insertions(+)
>
> applied

Thanks Jeff!

Feel free ignore the v2 I just sent out - it seems like the 0x3f19 cards
never made it out into the wild (or if anyone think it's worth it, I could send
an incremental patch that applies on top of this one)...

Mark
