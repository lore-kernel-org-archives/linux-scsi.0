From: dougg@gear.torque.net
Subject: Re: request sense and log sense in st driver
Date: Sun, 8 Sep 2002 12:16:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209081616.MAA31593@queen.tapscott.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Avinash@UltraBac.com, linux-scsi@vger.kernel.org

If you want this type of information, you need to use
the scsi generic (sg) driver. For examples of fetching
mode sense and log sense, see sg_mods and sg_logs in
the sg3_utils package found at www.torque.net/sg

Performing passive commands such as mode sense and
log sense via the sg interface at the same time as
accessing a tape via the st driver should be ok.

Doug Gilbert

---- Original Message ----
From:		Avinash Gowda
Date:		Sun 9/8/02 0:37
To:		'linux-scsi@vger.kernel.org'
Subject:	request sense and log sense in st driver

Hi:  I had a question on request sense and log sense in the st driver. I am trying 
to obtain the sense data (request and log sense) data for a scsi tape driver. These 
two operations are __NOT__ part of the header file mtio.h. and neither is it a part 
of st (driver). I would greatly appreciate if I can get some pointers on this. 

TIA. 

avinash
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

