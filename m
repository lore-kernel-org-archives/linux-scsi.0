From: Pat LaVarre <p.lavarre@ieee.org>
Subject: man ioctl CDROM_SEND_PACKET exists not
Date: Tue, 17 Aug 2004 15:47:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FDDF38A0-F096-11D8-81F9-00039398BB5E@ieee.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:59592 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268464AbUHQVqn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 17:46:43 -0400
Received: from royntex01.iomegacorp.com (franklin [10.1.1.83])
	by email.iomega.com (Postfix) with ESMTP id AEC6E1EA6
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2004 15:46:42 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Doc for app usage of the ioctl CDROM_SEND_PACKET for SCSI pass thru of 
up to 12 bytes of CDB does Not exist ... true?

Time with Google and with marc.theaimsgroup.com and with an author of a 
C S R app all say true.  In this way, C S R differs from ioctl SG_IO.  
Seems like somehow, for the struct cdrom_generic_command of 
include/linux/cdrom.h, everyone just knows:

a) the (none?) necessary padding of .cmd past the CDB length,
b) the (sizeof int?) necessary alignment of .buffer bytes and .buflen,
c) the (0 else trouble?) enumeration of .stat,
d) the (0 else verbose?) enumeration of .quiet,
e) the (sizeof struct request_sense?) min allocated length and 
preparation (memset to zero?) of .sense bytes,
f) the (ms?) units and (1?) min and (days?) max of .timeout,
g) etc.

?

Pat LaVarre
http://lxr.linux.no/ident?i=cdrom_generic_command

