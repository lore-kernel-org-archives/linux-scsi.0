From: Hannes Reinecke <hare@suse.de>
Subject: aic79xx update?
Date: Tue, 24 May 2005 15:22:53 +0200
Message-ID: <42932AAD.9060609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59576 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262047AbVEXNWy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 09:22:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Luben,

I did some patch regarding 'rmmod aic79xx' which got partially vetoed a=
s
the aic79xx driver should rather be updated to use the spi_transport
class as the aic7xxx driver already has.
Do you have any plans in that area?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
