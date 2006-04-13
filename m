From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: HBA self selection
Date: Thu, 13 Apr 2006 15:06:58 -0500
Message-ID: <1144958819.3474.54.camel@mulgrave.il.steeleye.com>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net>
	 <20060413152419.GD24104@parisc-linux.org>
	 <1144950427.3474.39.camel@mulgrave.il.steeleye.com>
	 <5CCF5F0F2514664CBE20FD24BCE17614044BFD@cceexc17.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41382 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932361AbWDMUIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 16:08:14 -0400
In-Reply-To: <5CCF5F0F2514664CBE20FD24BCE17614044BFD@cceexc17.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, 2006-04-13 at 13:35 -0500, Cameron, Steve wrote:
> If it's a bad idea for general usage... maybe some 
> way to permit it on a per scsi host basis?  Maybe a 
> way to enable/disable this feature thru sysfs or 
> something, with the default being disabled?
> 
> Otherwise our SNMP agents won't be able to know that
> fans failed, overtemp etc. in the storage box.

Erm, as I read the MSA30 documentation, it has fourteen drive bays.
That means it has 14 targets plus the processor, so since 16 is the
addressing capacity of a wide SPI bus, there doesn't seem to be a need
to have the initiator and the processor at the same ID ... what's the
reason they have to be?

James


