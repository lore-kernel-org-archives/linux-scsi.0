From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: SCSI IO Errors
Date: Tue, 9 Sep 2003 11:10:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200D9A54@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.py.intel.com ([146.152.216.3]:48861 "EHLO
	hermes.py.intel.com") by vger.kernel.org with ESMTP id S264170AbTIIPKz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2003 11:10:55 -0400
Received: from petasus.py.intel.com (petasus.py.intel.com [146.152.221.4])
	by hermes.py.intel.com (8.11.6p2/8.11.6/d: outer.mc,v 1.83 2003/09/05 14:45:27 rfjohns1 Exp $) with ESMTP id h89F67K16510
	for <linux-scsi@vger.kernel.org>; Tue, 9 Sep 2003 15:06:10 GMT
Received: from fmsmsxvs041.fm.intel.com (fmsmsxvs041.fm.intel.com [132.233.42.126])
	by petasus.py.intel.com (8.11.6p2/8.11.6/d: inner.mc,v 1.35 2003/05/22 21:18:01 rfjohns1 Exp $) with SMTP id h89FAXn24697
	for <linux-scsi@vger.kernel.org>; Tue, 9 Sep 2003 15:10:34 GMT
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthias Jaenichen <mj2@percomp.de>
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, linux-scsi@vger.kernel.org

Matthias,

You probably should also ask Seagate about the disk firmware rev 0010
for ST318436LW.
It may not be the latest firmware.  From what you indicate about the
traces, the disk 
firmware is the most likely at fault.

Andy

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Sunday, September 07, 2003 1:47 PM
To: Matthias Jaenichen
Cc: Jan-Benedict Glaw; linux-scsi@vger.kernel.org
Subject: Re: SCSI IO Errors


On Sad, 2003-09-06 at 19:59, Matthias Jaenichen wrote:
> (scsi0:A:0): 20.000MB/s transfers (10.000MHz, offset 31, 16bit)
>    Vendor: SEAGATE   Model: ST318436LW        Rev: 0010
>    Type:   Direct-Access                      ANSI SCSI revision: 03

>From the traces the disk is stopping responding, it then fails to
react to an abort and your trace ends at the reset issue so its hard to
see what happened then.

Does seatools show up anyting on the disk ?

Adaptec themselves have a forum for this stuff which is maintained by 
Justin Gibbs, the aic7xxx author

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
