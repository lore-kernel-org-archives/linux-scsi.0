From: "Grover, Andrew" <andrew.grover@intel.com>
Subject: RE: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 16:59:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <59885C5E3098D511AD690002A5072D3C02AB7F4D@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Linus Torvalds' <torvalds@transmeta.com>, Martin Schwenke <martin@meltin.net>
Cc: Andries Brouwer <aebr@win.tue.nl>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

> From: Linus Torvalds [mailto:torvalds@transmeta.com] 
> Bit if somehting is really _useful_ to export to user space 
> through the fs
> model and it makes things easier, that's probably good. Naming is
> definitely one of those things - I generally like how the 
> thing looks in a
> file managers tree-view, but some of the names suck and that 
> shows up cery 
> clearly at that point, liiking in at 10.000'.
> 
> (Tha ACPI "shouting disease" is really sad. I remember my old 
> VIC-20, and
> how you used all-caps, but I don't think the ACPI people were 
> sentimental.  
> They apparently just _like_ ugly four-letter ALL-CAPS names).

ACPI DEVC NAMS ARNT USED FOR MUCH. WE CAN <ahem> lowercase them in driverfs
and not hurt anything. The _HID entries under them are the more useful
thing, generally.

;-)

Regards -- Andy

PS I don't know about the caps but iirc 4 char names were to make names
small and fixed length. This theoretically resulted in easier compares by
casting to u32s, and a slightly simpler  interpreter. (hah)
