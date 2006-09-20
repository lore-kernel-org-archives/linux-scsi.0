From: <crazyrushstar@yahoo.com.tw>
Subject: scsi_scan_host will hang up my system!
Date: Wed, 20 Sep 2006 11:46:13 +0800 (CST)
Message-ID: <20060920034613.24075.qmail@web18305.mail.tpe.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web18305.mail.tpe.yahoo.com ([203.84.194.87]:20637 "HELO
	web18305.mail.tpe.yahoo.com") by vger.kernel.org with SMTP
	id S1751004AbWITDqQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 23:46:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am writing a driver for our product.
After research various drivers, I start to write my
driver.

Now when I instert my driver, my linux will stick with
this insmod cmd.
I trace this is due to this scsi_host_scan function.

Does this function require any speical parameter or
setting?
Does someone can advise me where the document of "scsi
related" is?
My driver is base on "linux device drivers,
3e"(O'REILLY). This book does not reference to scsi.

scsi_host_template
scsi_scan_host()
scsi_host_put()
Many functions ware uesd without really understand
what are they.

Thanks for your advice.


___________________________________________________=20
 =B1z=AA=BA=A5=CD=AC=A1=A7Y=AE=C9=B3q =A1=D0 =B7=BE=B3q=A1B=AET=BC=D6=A1=
B=A5=CD=AC=A1=A1B=A4u=A7@=A4@=A6=B8=B7d=A9w=A1I=20
 http://messenger.yahoo.com.tw/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
