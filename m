From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Caddy Plextor 12Plex
Date: Tue, 27 Jan 2004 23:02:08 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401272254140.2037-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:15846 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265045AbUA0WDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 17:03:12 -0500
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.35 #1 (Debian))
	id 1AlbHc-0000Xs-00
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2004 23:02:08 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I've got an old SCSI caddy-type CD-R, that works "sometimes". I.e.,
sometimes you insert a CD, and everything is ok - you can mount, read it,
but ejecting is only possible with "eject", the button has no effect. But
sometimes the same disk is inserted, and the ON/BUSY light starts
blinking, pressing / issuing eject only has the effect that the light
returns to the "ON" state. The disk is neither readable, nor ejectable.
Then the only way to get it out is with a pin. Then the disk goes out, but
still cannot be removed. To remove it another eject command / button press
is needed. But the CDR will not work at least until power-off / on.

The controller is an AM53C974. Same under 2.4 and 2.6. So, the question -
is the CDR physically dead, or is it possible to get it to work with some
extra software effort?

Thanks
Guennadi
---
Guennadi Liakhovetski


