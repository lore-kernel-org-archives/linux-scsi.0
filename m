From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Fri, 14 Sep 2007 22:20:55 +0200 (CEST)
Message-ID: <tkrat.3dfcbf93e471068a@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com>
 <p73fy1p9m57.fsf@bingen.suse.de>
 <1189371621.3526.28.camel@localhost.localdomain>
 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
 <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de>
 <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de>
 <tkrat.d922469e152fe0f3@s5r6.in-berlin.de>
 <tkrat.913e8b183cdf7888@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759872AbXINUWA@vger.kernel.org>
In-Reply-To: <tkrat.913e8b183cdf7888@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I wrote:
> Applies after patch "SCSI: update Kconfig help text to indicate SCSI
> core's widespread usage",

Actually the addition "This menu also presents options for specific SCSI
controllers..." from that patch is then no longer true.

> These two patches could very well be collapsed into one.

(I'll gladly do that, or only send an update of the 'split Kconfig menu'
patch with that sentence backed out, if desired.)
-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/
