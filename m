From: bburk@extremeprotocol.com
Subject: ATA QWORD buffer formatting
Date: Fri, 07 Nov 2008 09:31:24 -0700
Message-ID: <20081107093124.a3c6426c1bfee0652ed014f32bc3b38e.636e892f97.wbe@email.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpoutwbe04.prod.mesa1.secureserver.net ([208.109.78.206]:60980
	"HELO smtpoutwbe04.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750911AbYKGQb2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2008 11:31:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm a little fuzzy on the format of an ATA "QWORD" for the SCT commands.
 
 
http://www.t13.org/Documents/UploadedDocuments/docs2006/D1699r3e-ATA8_ACS.pdf
 
 
 
Assume a QWORD LBA of 0102030405060708, how is that arrayed in memory
when the bufer is formatted and sent?
 
Bytes 0-3 = action, etc
Byte04  = 08
Byte05  = 07
Byte06  = 06
Byte07  = 05
Byte08  = 04
Byte09  = 03
Byte10  = 02
Byte11  = 01
 
or
 
Bytes 0-3 = action, etc
Byte04  = 01
Byte05  = 02
Byte06  = 03
Byte07  = 04
Byte08  = 05
Byte09  = 06
Byte10  = 07
Byte11  = 08
 
 
or the wierd ATA endien byte/word shuffle instead?  How would that be
laid out?
 
 


