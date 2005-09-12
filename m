From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Mon, 12 Sep 2005 07:10:05 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919BB9@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:61918 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750733AbVILLKH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 07:10:07 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:
 
>> +			if (busy == 0) {
>> +				device->removable = 1;
> devce->removeable means the device has a removable medium, not that
> it can go away.

It also means that the capacity can change. The SCSI subsystem will
cache the partition table and capacity for the device if this is not
set.

-- Mark Salyzyn
