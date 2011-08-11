From: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Subject: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Thu, 11 Aug 2011 17:18:27 +0200
Message-ID: <4E43F2C3.9000808@computerix.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www74.your-server.de ([213.133.104.74]:55002 "EHLO
	www74.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1HKPlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 11:41:12 -0400
Received: from [78.46.5.203] (helo=sslproxy01.your-server.de)
	by www74.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <klaus.kusche@computerix.info>)
	id 1QrX1s-0006Y2-2r
	for linux-scsi@vger.kernel.org; Thu, 11 Aug 2011 17:18:40 +0200
Received: from [195.243.195.230] (helo=[10.10.0.222])
	by sslproxy01.your-server.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <klaus.kusche@computerix.info>)
	id 1QrX7C-0003NB-2P
	for linux-scsi@vger.kernel.org; Thu, 11 Aug 2011 17:24:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm looking for ways to hook up fast 6 Gb/s SATA SSD's (non-RAID!)
to (server or i-X58) mainboards which do not have native 6 Gb/s SATA.

 From the reviews I've read so far, two things became obvious:
* The SSD's I'm looking at really want a working SATA TRIM command.
* All the onboard Marvell 88SE9128 (or ASmedia) solutions
seriuosly lack performance, as do PCIe cards based on those chips.

So basically, there seem to be two choices:
1.) LSI 2008
2.) Marvell 9485

1.) seems to be fast, reliable and well-supported,
but as far as I can tell, it doesn't support TRIM at all:
It neither maps SCSI unmap to SATA TRIM,
nor accepts TRIM as a SATA passthrough command.

Is that true?

I didn't find much about 2.)
* The only cards based on this chip are the HighPoint 27xx,
or did I miss something?
* Running a 27xx with the mvsas driver was reported to have stability
problems or random errors. Are these problems solved?
* Is the 27xx fast (with SATA SSD's & mvsas driver),
i.e. significantly faster than onboard SATA 3 Gb/s ports?
* Does the 27xx+mvsas support TRIM when connected to SATA drives?

Are there any other solutions?

--=20
Prof. Dr. Klaus Kusche
Private address: Rainstra=DFe 9/1, 88316 Isny, Germany
+49 7562 6211377 Klaus.Kusche@computerix.info http://www.computerix.inf=
o
Office address: NTA Isny gGmbH, Seidenstra=DFe 12-35, 88316 Isny, Germa=
ny
+49 7562 9707 36 kusche@nta-isny.de http://www.nta-isny.de

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
