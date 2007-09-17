From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Mon, 17 Sep 2007 16:46:21 +0200
Message-ID: <46EE933D.60207@s5r6.in-berlin.de>
References: <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <Pine.LNX.4.64N.0709171217350.17606@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58299 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbXIQOqX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 10:46:23 -0400
In-Reply-To: <Pine.LNX.4.64N.0709171217350.17606@blysk.ds.pg.gda.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  SCSI is a generic peripheral bus

No, not anymore.  http://www.t10.org/scsi-3.htm

> (recall the expansion of the acronym).

The expansion of the acronym doesn't fit anymore to what SCSI is today,
or even to what it became already circa 10 years ago.

> Even though probably the most common, storage is one of its applications 
> only (think scanners for an immediately obvious other one).  I find 
> describing CONFIG_SCSI as "storage support" misleading and inappropriate.

Right.  I wrote that in lack of better words, but at least I added "SCSI
commands" in parentheses.  Something like "SCSI I/O - core and command
sets" would much better describe what it is, but it would put "SCSI"
first again and thus wouldn't reflect that  Linux' SCSI core and
highlevel is in broader use than just for actual SCSI hardware...  Of
course there is no way around the issue that Linux' SCSI core's and
highlevel's role cannot be characterized in 3...6 words only, but there
should be a way to point out its general importance.

>  Referring to your example it is like calling generic networking (i.e. 
> CONFIG_NET) "Ethernet support".

Wrong comparison.
-- 
Stefan Richter
-=====-=-=== =--= =---=
http://arcgraph.de/sr/
