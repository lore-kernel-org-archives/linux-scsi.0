From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] [Resend] update aic79xx sequencer
Date: Thu, 12 Jan 2006 12:02:58 +0100
Message-ID: <43C63762.3000501@suse.de>
References: <ISX88H$7860D422B0F4A207532BB4F4448FF0FD@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56283 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932169AbWALLDI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 06:03:08 -0500
In-Reply-To: <ISX88H$7860D422B0F4A207532BB4F4448FF0FD@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "emmanuel.fuste" <emmanuel.fuste@laposte.net>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>

Hi all,

this is a resend of the aic79xx update; I've removed the offending
copyright changes and merged patch 2&3.

Jeff, the inb/outb changes have been done by adaptec, so I really do
hope they've done proper testing on them.
I certainly haven't seen any untoward effects here locally.

Mark, were you able to test them? Or can you give some comments?
As already noted, I'll probably do another update to the latest adaptec
sources; wind and weather permitting as usual.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
