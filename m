From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 12:06:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412A15EC.8040903@pobox.com>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patlinux.iomegacorp.com> <20040823154648.GB2301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:64716 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266081AbUHWQGO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 12:06:14 -0400
In-Reply-To: <20040823154648.GB2301@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> Ok, makes more sense to me now. The reason why I get confused is that I
> don't consider the cdb more than the actual 10-16 bytes of command data
> bytes, not the full structure of it.


Speaking of which...  (WARNING: change of topic; or perhaps, getting 
back on topic :))


I would like to see support for CDBs larger than 16 bytes in struct request.

Problem:  Would like to support SCSI's variable length CDBs, and support 
  non-{ATA,SCSI} RAID CDBs which are often larger than 16 bytes, such as 
Promise's SX8 (formerly known as carmel).

Suggested solution:  Probably this involves adding a flag and a pointer, 
rather than increasing the actual CDB buffer size in struct request.

	Jeff


