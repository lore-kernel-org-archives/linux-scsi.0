From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Request for moving Sg_request into sg.h
Date: Tue, 08 Mar 2005 10:57:50 +0100
Message-ID: <422D771E.6070104@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from s0003.shadowconnect.net ([213.239.201.226]:9146 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261951AbVCHJ6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2005 04:58:07 -0500
Received: from pd952319f.dip.t-dialin.net ([217.82.49.159] helo=[192.168.1.52])
	by mail.shadowconnect.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.43)
	id 1D8bTa-0007nU-Fm
	for linux-scsi@vger.kernel.org; Tue, 08 Mar 2005 10:58:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

i wanted to ask if it is possible to put the typedef "Sg_request" into sg.h?

The reason i'm asking is, i need to pass data through SG_IO from an 
application to the driver. At the moment the problem is solved by copying 
code of the SG_IO driver into i2o_config (the passthru function). I'm 
working on removing the passthru function and instead using the SG_IO 
interface, but therefore i need to pass some additional data to the 
driver. I could use the use the "flags" and "usr_ptr" fields in 
sg_io_hdr_t, but i need to get access to them through "Sg_request".

Any comments appreciated.


Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
