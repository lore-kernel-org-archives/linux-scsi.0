From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: convert 520 byte sector disk to 512 byte sector?
Date: Tue, 10 Jun 2003 11:32:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D91A@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr06.intel.com ([134.134.136.7]:20216 "EHLO
	caduceus.jf.intel.com") by vger.kernel.org with ESMTP
	id S261773AbTFJSNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2003 14:13:55 -0400
Received: from petasus.jf.intel.com (petasus.jf.intel.com [10.7.209.6])
	by caduceus.jf.intel.com (8.11.6p2/8.11.6/d: outer.mc,v 1.66 2003/05/22 21:17:36 rfjohns1 Exp $) with ESMTP id h5AIMGo08493
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2003 18:22:16 GMT
Received: from orsmsxvs040.jf.intel.com (orsmsxvs040.jf.intel.com [192.168.65.206])
	by petasus.jf.intel.com (8.11.6p2/8.11.6/d: inner.mc,v 1.35 2003/05/22 21:18:01 rfjohns1 Exp $) with SMTP id h5AIN5T11442
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2003 18:23:05 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Grant Grundler' <iod00d@hp.com>, Douglas Gilbert <dougg@torque.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Grant,

You can set the block descriptor as part of the mode page file using sgmode
from
  http://scsirastools.sourceforge.net
You must do a SCSI format of the disk after changing the block size, of
course.

Andy

-----Original Message-----
From: Grant Grundler [mailto:iod00d@hp.com] 
Sent: Tuesday, June 10, 2003 1:24 PM
To: Douglas Gilbert
Cc: Patrick Mansfield; linux-scsi@vger.kernel.org
Subject: Re: convert 520 byte sector disk to 512 byte sector?


On Tue, Jun 10, 2003 at 11:53:56AM +1000, Douglas Gilbert wrote:
> www.seagate.com have a tool called "seatool" that may
> do the trick for you.

Doug,
thanks - but last time I checked, it's an x86 binary only driver.
I guess I could try it anyway and see if the IOCTLs have
32-bit compat support in ia64 kernel.

thanks,
grant
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
