From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: what to do with dpt_i2o
Date: Mon, 11 Oct 2004 08:28:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B2FC25E@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:29079 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268877AbUJKM27 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 08:28:59 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

I have not been submitting an updated patch for the dpt_i2o driver
because of a handful of customers experiencing problems with >4G of
memory in certain systems (all Zero Channel RAID). I am still
investigating.

The hot-changing of devices is still using a controversial interface
(busy checks wrapped around calls to driver writes to /proc/scsi/scsi in
2.4, and the drv->rescan() or scsi_rescan_device in 2.6) and there is
resistance to the LLD/car Firmware knowing more about device status.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Markus Lidel [mailto:Markus.Lidel@shadowconnect.com] 
Sent: Monday, October 11, 2004 4:30 AM
To: Christoph Hellwig
Cc: Salyzyn, Mark; linux-scsi@vger.kernel.org
Subject: Re: what to do with dpt_i2o

Hello,

Christoph Hellwig wrote:
>>Marcus, you'd been doing a lot of testing with the DPT/Adaptec cards
for
>>the new i2o layer, right?  IIRC we now have both support for the
Adaptec
>>managment utils and the optimizes sglist format, so there's probably
no
>>reason anymore to keep dpt_i2o.

Maybe i should list some remaining issues:

- 64 bit Scatter Gather elements
- supports hot-changing of devices, and array changes without a reboot.

The second one is implemented, but didn't work on my system. I didn't 
have the time to verify if the dpt_i2o driver recognize it if a drive
fails.


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
