From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it
 isn't provided
Date: Fri, 05 Dec 2014 16:49:41 +0100
Message-ID: <5481D415.3070102@redhat.com>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>	<yq1r3wefe6o.fsf@sermon.lab.mkp.net> <CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaLEPty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 10:49:54 -0500
In-Reply-To: <CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>



On 05/12/2014 14:05, Ming Lei wrote:
> 
> [   50.112885] sd 0:0:1:0: [sda] FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [   50.113859] sd 0:0:1:0: [sda] Sense Key : Illegal Request [current]
> [   50.113859] sd 0:0:1:0: [sda] Add. Sense: Invalid field in cdb
> [   50.113859] sd 0:0:1:0: [sda] CDB:
> [   50.113859] Write same(16): 93 08 00 00 00 00 00 00 80 00 00 40 00 00 00 00
> [   50.113859] blk_update_request: critical target error, dev sda, sector
> 32768

So this command is zeroing 2^22 sectors (2GB) starting from sector 128.
 How did you run QEMU and what command produced this request?

Paolo
