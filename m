From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 12:41:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC514AD.4000504@pobox.com>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC509A1.10503@pobox.com> <20030516160502.GE812@suse.de> <3EC51235.8090701@pobox.com> <20030516163558.GH812@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:43722 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264489AbTEPQ2p
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 12:28:45 -0400
In-Reply-To: <20030516163558.GH812@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> How would you shoehorn any given ata command into a scsi
> command?


Make up a vendor-specific scsi opcode, say 0x70.  Define this opcode 
such that it carries the ATA taskfile registers as cdb parameters.  Look 
at the taskfile as passed in the cdb to classify it (a la 
req_file->data_phase in drivers/ide).  Then execute it.

	Jeff


