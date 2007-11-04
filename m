From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] scsi menu: move RAID transport class to Transports menu
Date: Sun, 04 Nov 2007 14:00:10 -0500
Message-ID: <472E16BA.4090708@garzik.org>
References: <20071104104423.d595c0e7.randy.dunlap@oracle.com> <20071104185806.GV15111@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58615 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXKDTAY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Nov 2007 14:00:24 -0500
In-Reply-To: <20071104185806.GV15111@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>

Matthew Wilcox wrote:
> On Sun, Nov 04, 2007 at 10:44:23AM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Move RAID_ATTRS into the SCSI Transports sub-menu.
>> Fix some help text whitespace in Transports.
> 
> Ummm ... RAID isn't really a SCSI property, is it?  How about putting it
> in block/Kconfig?

Agreed.

IMO would be nice to emphasize that the RAID transport attributes are 
not necessarily SCSI-specific.

	Jeff



