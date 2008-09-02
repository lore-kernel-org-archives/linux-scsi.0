From: "Mark Nelson" <mdnelson8@gmail.com>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 2 Sep 2008 21:55:49 +1000
Message-ID: <65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	 <48BD2136.1020101@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:9243 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYIBLzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2008 07:55:50 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1309867yxm.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Sep 2008 04:55:49 -0700 (PDT)
In-Reply-To: <48BD2136.1020101@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Sep 2, 2008 at 9:19 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Mark Nelson wrote:
>>
>> Add an appropriate entry for the Promise PDC42819 controller. It has an
>> AHCI mode and seems to work correctly with board_ahci.
>>
>> This chip is found on Promise's FastTrak TX2650 (2 port) and TX4650 (4
>> port)
>> software-based RAID cards (for which there is a binary driver, t3sas) and
>> can be found on some motherboards, for example the MSI K9A2 Platinum,
>> which calls the chip a Promise T3 controller.
>>
>> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
>> ---
>> Apparently this chip also supports SAS disks, will these work with the
>> ahci driver (I've only tested with normal desktop SATA disks)?
>
> ahci is definitely SATA-only, so I wonder how they modified AHCI to support
> SAS transport...

That is a good question. From my understanding the controller is a SAS
controller that can drive SATA disks (as I guess all SAS controllers can
do...). Could it be that the controller can be setup to act as an AHCI
SATA controller or if the right registers are poked a SAS controller?

Thanks!

Mark

>
>        Jeff
>
>
>
>
