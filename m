From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 15:14:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412A41FE.2070905@adaptec.com>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patlinux.iomegacorp.com> <20040823154648.GB2301@suse.de> <412A15EC.8040903@pobox.com> <412A3BE5.4090203@adaptec.com> <412A4046.6040007@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48347 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267442AbUHWTOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 15:14:10 -0400
In-Reply-To: <412A4046.6040007@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> At the struct request level a flag is needed.  A "CDB" may be a SCSI
> CDB, an ATA taskfile, an I2O command, etc.  The block layer must treat
> any cdb buffer as an anonymous blob that gets passed through to a lower
> layer.

Ah, yes, that's true -- I missed the fact that you were talking
considering the flag at the struct request level.

		Luben


