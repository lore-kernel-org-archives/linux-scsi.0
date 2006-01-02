From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Mon, 02 Jan 2006 14:43:33 -0500
Message-ID: <yq1oe2u2z6i.fsf@wilson.lab.mkp.net>
References: <1135801791.9541.12.camel@gateway.markschaefer.org>
	<200512290845.17192@bilbo.math.uni-mannheim.de>
	<62187.24.3.12.198.1135893081.squirrel@www.markschaefer.org>
	<200512292302.50743@bilbo.math.uni-mannheim.de>
	<yq1oe2y44bf.fsf@wilson.lab.mkp.net>
	<1136168563.3768.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:47817 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1750980AbWABTnf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jan 2006 14:43:35 -0500
In-Reply-To: <1136168563.3768.3.camel@localhost.localdomain> (Mark Schaefer's message of "Sun, 01 Jan 2006 21:22:43 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Schaefer <mark@markschaefer.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-scsi@vger.kernel.org

>>>>> "Mark" == Mark Schaefer <mark@markschaefer.org> writes:

Mark> 	Also, any info on the Tachyon chips would be helpful.  I have
Mark> a TS and a HPFC-5000C (32-bit old chip).

HPFC-5000 is the original HP Tachyon design which my driver won't
support.  It doesn't have FCP support in hardware or anything.  My
driver only does TachLite.

My aim is to support the following boards:

HP A5156A	HPFC-5100 /2.0	(TL)
HP A5157A	HPFC-5100B/2.2	(TL) dual port
HP A5158A	HPFC-5100C/2.3	(TL)
HP A5158A	HPFC-5100D/3.0	(TL)
HP A6795A	HPFC-5200C/2.2	(XL2)
Compaq FC HBA   HPFC-5166A/1.2  (TS)

The Compaq FC HBA is the one that the RA-4x00 people have.  I don't
have this controller yet but there should be one waiting for me at the
post office once the world goes out of suspend mode tomorrow...

-- 
Martin K. Petersen      http://mkp.net/
