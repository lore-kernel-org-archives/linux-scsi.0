From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 4/8] aacraid: add name to driver template
Date: Mon, 12 Sep 2005 07:15:29 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919BBD@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54495 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750739AbVILLPa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 07:15:30 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig writes:
>> +	aac_driver_template.name = aac_drivers[index].name;
>this is broken. it overwrites the name every time a host is allocated.
Especially it does this on a live template.  Just implemented ->info

->info() is not enough, there are places in the scsi subsystem which do
not implement the info override over top the template name.

I had discussed the possibility of submitting a patch to the scsi
subsystem to fix that brokenness, I am generally concerned with legacy
issues.

Sincerely -- Mark Salyzyn
