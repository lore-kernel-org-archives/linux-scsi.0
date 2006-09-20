From: <crazyrushstar@yahoo.com.tw>
Subject: Fwd: Re: scsi_scan_host will hang up my system!
Date: Wed, 20 Sep 2006 18:58:45 +0800 (CST)
Message-ID: <20060920105845.48447.qmail@web18301.mail.tpe.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web18301.mail.tpe.yahoo.com ([203.84.194.83]:52386 "HELO
	web18301.mail.tpe.yahoo.com") by vger.kernel.org with SMTP
	id S1751105AbWITK6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 06:58:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am still reading scsi_mid_low_api.txt file.

Report my newly discovery.
Trace to kernel code,function call to
"blk_execute_rq(req->q, NULL, req, 1);" at scsi_lib.c
It's too deep to trace.

This function not response to my driver so that insmod
stuck.

If you are well known on this please tell me what=20
wrong is!



___________________________________________________=20
 =B1z=AA=BA=A5=CD=AC=A1=A7Y=AE=C9=B3q =A1=D0 =B7=BE=B3q=A1B=AET=BC=D6=A1=
B=A5=CD=AC=A1=A1B=A4u=A7@=A4@=A6=B8=B7d=A9w=A1I=20
 http://messenger.yahoo.com.tw/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
