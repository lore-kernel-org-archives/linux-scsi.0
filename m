From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 2 Sep 2008 14:08:02 +0200
Message-ID: <18621.11426.870514.781750@harpo.it.uu.se>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	<48BD2136.1020101@garzik.org>
	<65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aun.it.uu.se ([130.238.12.36]:38618 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYIBMIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 08:08:46 -0400
In-Reply-To: <65a6ef750809020455q7b7ee6a8jc404b4970f660c50@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Nelson <mdnelson8@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>, linux-scsi <linux-scsi@vger.kernel.org>

Mark Nelson writes:
 > On Tue, Sep 2, 2008 at 9:19 PM, Jeff Garzik <jeff@garzik.org> wrote:
 > > Mark Nelson wrote:
 > >>
 > >> Add an appropriate entry for the Promise PDC42819 controller. It has an
 > >> AHCI mode and seems to work correctly with board_ahci.
 > >>
 > >> This chip is found on Promise's FastTrak TX2650 (2 port) and TX4650 (4
 > >> port)
 > >> software-based RAID cards (for which there is a binary driver, t3sas) and
 > >> can be found on some motherboards, for example the MSI K9A2 Platinum,
 > >> which calls the chip a Promise T3 controller.
 > >>
 > >> Signed-off-by: Mark Nelson <mdnelson8@gmail.com>
 > >> ---
 > >> Apparently this chip also supports SAS disks, will these work with the
 > >> ahci driver (I've only tested with normal desktop SATA disks)?
 > >
 > > ahci is definitely SATA-only, so I wonder how they modified AHCI to support
 > > SAS transport...
 > 
 > That is a good question. From my understanding the controller is a SAS
 > controller that can drive SATA disks (as I guess all SAS controllers can
 > do...). Could it be that the controller can be setup to act as an AHCI
 > SATA controller or if the right registers are poked a SAS controller?

Based on how the sata_promise-supported chips work I'd guess that they
have dual programming interfaces with AHCI for JBOD SATA and a native
one (perhaps just additional control registers) for SAS and raid.
