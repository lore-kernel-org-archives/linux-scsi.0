From: Ed Jaeger <ed.jaeger@bgcorp.com>
Subject: Trantor T128 driver does not recognize some cards (with fix)
Date: Wed, 26 Jun 2002 16:28:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D1A4E39.3090002@bgcorp.com>
Reply-To: ed.jaeger@bgcorp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Please accept my apologies if this is not submitted correctly - I believe I am 
following the FAQ.

The Trantor T128 driver (t128.o) does not recognize some cards.

I have a card with ROM version 1.06a, but the initialization code looks for 
version 1.12 and does not recognize my card.  If the string used in the 
initialization routine is changed the card is recognized and operates properly.

The patch I made to linux/drivers/scsi/t18.c:

149c149
<       {"TSROM: SCSI BIOS, Version 1.", 0x36},
---
 >       {"TSROM: SCSI BIOS, Version 1.12", 0x36},

I am not subscribed to the list, so email me directly as well if you need to 
contact me.
-- 
Ed Jaeger, President & CFO, Bohlender Graebener Corporation
ed.jaeger@bgcorp.com
http://www.bgcorp.com
---

