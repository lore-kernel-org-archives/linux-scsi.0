From: Bernd Schubert <bernd.schubert@pci.uni-heidelberg.de>
Subject: Re: a couple of oopses with 2.6.14
Date: Fri, 10 Feb 2006 19:24:44 +0100
Message-ID: <200602101924.45467.bernd.schubert@pci.uni-heidelberg.de>
References: <200602091934.20732.bernd.schubert@pci.uni-heidelberg.de> <20060209152744.00de43f6.akpm@osdl.org>
Reply-To: bernd-schubert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:59078 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S1751306AbWBJSZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2006 13:25:00 -0500
In-Reply-To: <20060209152744.00de43f6.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> Can you test 2.6.15?

Yes, 2.6.15.3 works, no oopses. Only this information=20

[4294743.341000] scsi0 : ata_piix
[4294743.514000] ATA: abnormal status 0x7F on port 0xE407

I can't test if sata works, there's just nothing connected.

Btw, the printk timing information seem to be uninitalized, is this by=20
intentention or is it a bug?

Thanks,
	Bernd


--=20
Bernd Schubert
Physikalisch Chemisches Institut / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg
e-mail: bernd.schubert@pci.uni-heidelberg.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
