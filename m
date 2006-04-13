From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: HBA self selection
Date: Thu, 13 Apr 2006 13:35:19 -0500
Message-ID: <5CCF5F0F2514664CBE20FD24BCE17614044BFD@cceexc17.americas.cpqcorp.net>
References: <5CCF5F0F2514664CBE20FD24BCE17614044BF8@cceexc17.americas.cpqcorp.net><20060413152419.GD24104@parisc-linux.org> <1144950427.3474.39.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:43190 "EHLO
	ccerelbas01.cce.hp.com") by vger.kernel.org with ESMTP
	id S964827AbWDMSfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2006 14:35:40 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:

> Steve, how exactly is this supposed to work?  The SPI 
> protocol wasn't designed to allow two devices on the bus 
> with the same ID.  I'm assuming the device doesn't do all 
> the things that simply can't work, like disconnect/reconnect?

I don't really know how it's made to work.

If it's a bad idea for general usage... maybe some 
way to permit it on a per scsi host basis?  Maybe a 
way to enable/disable this feature thru sysfs or 
something, with the default being disabled?

Otherwise our SNMP agents won't be able to know that
fans failed, overtemp etc. in the storage box.

-- steve
