From: olecom@mail.ru
Subject: [sbp2] external hard disk shutdown timer
Date: Tue, 08 Aug 2006 01:05:49 +0400
Message-ID: <E1GACIH-00043x-00.olecom-mail-ru@f58.mail.ru>
Reply-To: olecom@mail.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from f58.mail.ru ([194.67.57.92]:49156 "EHLO f58.mail.ru")
	by vger.kernel.org with ESMTP id S932289AbWHGVFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2006 17:05:50 -0400
Received: from mail by f58.mail.ru with local
	id 1GACIH-00043x-00
	for linux-scsi@vger.kernel.org; Tue, 08 Aug 2006 01:05:49 +0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hallo ! Let me ask a question.

I couldn't change some values (f.e IDLE or ICT), while its
"changing" flag is "y".

Would you like to explain meaning of that flag and, possibly,
why change doesn't apply ? Maybe i'm doing or understanding
something wrong ?

All i want is to switch off timers (AFAIR from spcecs i've found t10.org),
that shutdown ieee1394/usb-storage external HDD.
 
TIA.
 
 deen:/home/olecom# sdparm --set=IDLE=0 -6 /dev/sda
    /dev/sda: WD        2500JB External   2.23  [simplified direct access device]
 Request sense detected:  Sense key: Blank Check
  ASC=55, ASCQ=55
    continuing ...
 deen:/home/olecom# sdparm -p po -6 /dev/sda
    /dev/sda: WD        2500JB External   2.23  [simplified direct access device]
 Request sense detected:  Sense key: Medium Error
  ASC=55, ASCQ=55
    continuing ...
 Power condition mode page:
 >>> warning: mode page seems malformed, try '--flexible'
  IDLE        1  [cha: y, def:  1, sav:  1]
  STANDBY     0  [cha: n, def:  0, sav:  0]
  ICT       4095  [cha: y, def:4095, sav:4095]
  SCT       4278190080  [cha: y, def:4278190080, sav:4278190080]
 deen:/home/olecom#
 
--
-o--=O`C
 #oo'L O
<___=E M
 

