From: Hannes Reinecke <hare@suse.de>
Subject: [Patch 0/2] Update aic79xx
Date: Fri, 22 Jul 2005 16:40:50 +0200
Message-ID: <42E10572.6030105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:57007 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262089AbVGVOk5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 10:40:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

Hi James,

I've finished the update of aic79xx to make use of the
scsi_transport_spi infrastructure.
The first patch is actually jgarzik's one, with some additions to make
it work :-)
The second patch is the integration proper. patch made a mess of it,
however, so better to compare the files by hand ...

Hope it finds your blessing.
Comments etc welcome.

target27:0:10: FAST-160 WIDE SCSI 320.0 MB/s ST IU (6.25 ns, offset 127=
)

Cool, eh?

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
