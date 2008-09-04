From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Thu, 04 Sep 2008 06:37:18 -0400
Message-ID: <48BFBA5E.5050300@garzik.org>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>	 <48BD2136.1020101@garzik.org>	 <65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>	 <18621.11426.870514.781750@harpo.it.uu.se> <65a6ef750809020521wfaca733r8253795860b95f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60035 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYIDKhX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2008 06:37:23 -0400
In-Reply-To: <65a6ef750809020521wfaca733r8253795860b95f4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Nelson <mdnelson8@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Mark Nelson wrote:
> On Tue, Sep 2, 2008 at 10:08 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>> Mark Nelson writes:
>>  > On Tue, Sep 2, 2008 at 9:19 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>  > > Mark Nelson wrote:
>>  > >>
>>  > >> Add an appropriate entry for the Promise PDC42819 controller. It has an
>>  > >> AHCI mode and seems to work correctly with board_ahci.
>>  > >>
>>  > >> This chip is found on Promise's FastTrak TX2650 (2 port) and TX4650 (4
>>  > >> port)
>>  > >> software-based RAID cards (for which there is a binary driver, t3sas) and
>>  > >> can be found on some motherboards, for example the MSI K9A2 Platinum,
>>  > >> which calls the chip a Promise T3 controller.
>>  > >>
>>  > >> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
>>  > >> ---
>>  > >> Apparently this chip also supports SAS disks, will these work with the
>>  > >> ahci driver (I've only tested with normal desktop SATA disks)?
>>  > >
>>  > > ahci is definitely SATA-only, so I wonder how they modified AHCI to support
>>  > > SAS transport...
>>  >
>>  > That is a good question. From my understanding the controller is a SAS
>>  > controller that can drive SATA disks (as I guess all SAS controllers can
>>  > do...). Could it be that the controller can be setup to act as an AHCI
>>  > SATA controller or if the right registers are poked a SAS controller?
>>
>> Based on how the sata_promise-supported chips work I'd guess that they
>> have dual programming interfaces with AHCI for JBOD SATA and a native
>> one (perhaps just additional control registers) for SAS and raid.
>>
> 
> That's interesting; and makes sense. I'm guessing that we won't end up
> with an open source driver that can do SAS on these chips then... But
> for now at least we can use them as SATA controllers and if Promise
> wants to come to the table with specs or datasheets they can in the
> future. I'm just happy to be able to use my eSATA ports (and perhaps
> the possibility of getting my hard disk off the SB600, although I should
> benchmark both controllers before jumping to any conclusions).

FWIW, I'll poke my Promise contacts, but they have gone mostly silent in 
the past year, so don't get your hopes up...

	Jeff




