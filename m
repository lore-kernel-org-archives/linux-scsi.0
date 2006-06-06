From: Fabian Knittel <fabian.knittel@avona.com>
Subject: Re: [PATCH] sata_promise: Port enumeration order - SATA 150 TX4,
 SATA 300 TX4
Date: Tue, 06 Jun 2006 19:27:17 +0200
Message-ID: <4485BAF5.9060507@avona.com>
References: <43FFAE3D.7010002@physics.harvard.edu> <44000036.7070403@eyal.emu.id.au> <011f01c639f9$8dc86bc0$3d64880a@speedy> <442DB29D.1010102@avona.com> <447CB9B4.50700@physics.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <447CB9B4.50700@physics.harvard.edu>
Sender: linux-ide-owner@vger.kernel.org
To: Milan Kupcevic <milan@physics.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Eyal Lebedinsky <eyal@eyal.emu.id.au>, Stan Seibert <volsung@mailsnare.net>, linux-ide@vger.kernel.org, Christiaan den Besten <chris@scorpion.nl>
List-Id: linux-scsi@vger.kernel.org

Milan Kupcevic wrote:
> Please respond with this data:
> 
> - Your Promise SATA controller retail name
> - Chip label (PDCxxxxx)
> - PCI vendor and device code as you can get with "lspci -n"
> - Say if the controler has the new or the old wiring

We only have one card and it matches one of yours:

  Retail name: SATAII150 TX4
  Chip label: PDC40518  SATAII150
  Vendor-Device number: 105a:3d18 (rev 02)
  Wiring: NEW

Greetings, Fabian
-- 
avona media GbR      | Neureuter Str. 5-7   | D-76185 Karlsruhe
fon +49 721 53169901 | fax +49 721 53169904 | www.avona.com
