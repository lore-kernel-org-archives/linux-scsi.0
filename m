From: Jens Axboe <axboe@suse.de>
Subject: Re: "do ata" scsi command?
Date: Fri, 16 May 2003 18:43:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516164320.GK812@suse.de>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC509A1.10503@pobox.com> <20030516160502.GE812@suse.de> <3EC51235.8090701@pobox.com> <20030516163558.GH812@suse.de> <3EC514AD.4000504@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:38566 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264485AbTEPQa1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 12:30:27 -0400
Content-Disposition: inline
In-Reply-To: <3EC514AD.4000504@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Fri, May 16 2003, Jeff Garzik wrote:
> Jens Axboe wrote:
> >How would you shoehorn any given ata command into a scsi
> >command?
> 
> 
> Make up a vendor-specific scsi opcode, say 0x70.  Define this opcode 
> such that it carries the ATA taskfile registers as cdb parameters.  Look 
> at the taskfile as passed in the cdb to classify it (a la 
> req_file->data_phase in drivers/ide).  Then execute it.

As I wrote in the last email, I think this is about the ugliest idea (or
close to) I've ever heard. You can't just go around making up opcodes.

-- 
Jens Axboe

