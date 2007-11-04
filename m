From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] block: move RAID transport class to BLOCK menu
Date: Sun, 04 Nov 2007 12:02:47 -0800
Message-ID: <472E2567.4010304@oracle.com>
References: <20071104104423.d595c0e7.randy.dunlap@oracle.com> <20071104185806.GV15111@parisc-linux.org> <472E16BA.4090708@garzik.org> <472E1FD7.1010508@oracle.com> <472E2458.7060905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:46137 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXKDUEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 15:04:10 -0500
In-Reply-To: <472E2458.7060905@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>, Jens Axboe <jens.axboe@oracle.com>

Jeff Garzik wrote:
> Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Move RAID class configuration to the BLOCK menu since it is not
>> SCSI-specific.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>> block/Kconfig        |    5 +++++
>> drivers/scsi/Kconfig |    7 -------
>> 2 files changed, 5 insertions(+), 7 deletions(-)
> 
> ACK
> 
> Though IMO we should move the code, too.

OK, I'll do that and resend.

-- 
~Randy
