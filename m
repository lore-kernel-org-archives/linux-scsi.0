From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 14:48:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412A3BE5.4090203@adaptec.com>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patlinux.iomegacorp.com> <20040823154648.GB2301@suse.de> <412A15EC.8040903@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:50126 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266631AbUHWSsQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 14:48:16 -0400
In-Reply-To: <412A15EC.8040903@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

> I would like to see support for CDBs larger than 16 bytes in struct 
> request.
> 
> Problem:  Would like to support SCSI's variable length CDBs, and support
>   non-{ATA,SCSI} RAID CDBs which are often larger than 16 bytes, such as
> Promise's SX8 (formerly known as carmel).
> 
> Suggested solution:  Probably this involves adding a flag and a pointer,
> rather than increasing the actual CDB buffer size in struct request.

Not sure that you need a flag.
Op. code 0x7F implies (cdb->acdb != 0 && cdb[7] > 0), else bug.

		Luben


