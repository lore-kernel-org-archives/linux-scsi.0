From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Issuing SCSI command 'MODE SENSE'
Date: Tue, 12 Nov 2002 06:01:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D386@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmsmsxvs043.fm.intel.com (fmsmsxvs043.fm.intel.com [132.233.42.129])
	by petasus.ch.intel.com (8.11.6/8.11.6/d: solo.mc,v 1.48 2002/10/16 23:47:34 dmccart Exp $) with SMTP id gACE0g726373
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2002 14:00:42 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Nirmala S' <nmala@mail.com>, linux-scsi@vger.kernel.org

Mala,

The LUN should be passed in as part of the host:chan:targ:lun addressing.
Use SCSI_IOCTL_GET_IDLUN to return it.  

If you are building a utility, I have some code that shows this and the
length stuff for mode sense, see http://scsirastools.sourceforge.net
(sgmode.c & sgsub.c).

scsiinfo is another open-source tool that shows mode sense usage.

Andy

-----Original Message-----
From: Nirmala S [mailto:nmala@mail.com] 
Sent: Tuesday, November 12, 2002 8:38 AM
To: linux-scsi@vger.kernel.org
Subject: Issuing SCSI command 'MODE SENSE'


Hi,

While using the MODE SENSE command how does one calculate the "Allocation
Length" MSB, LSB, the LUN no. and the length of the data returned by the
command.

Kindly let me know.

Thanks and Regards,
Mala
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

Single & ready to mingle? lavalife.com:  Where singles click. Free to
Search!
http://www.lavalife.com/mailcom.epl?a=2116

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
