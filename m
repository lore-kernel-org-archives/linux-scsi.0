From: Luben Tuikov <tluben@rogers.com>
Subject: Re: "do ata" scsi command?
Date: Sat, 17 May 2003 03:49:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC5E984.90408@rogers.com>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC509A1.10503@pobox.com> <20030516160502.GE812@suse.de> <3EC51235.8090701@pobox.com> <20030516163558.GH812@suse.de> <3EC514AD.4000504@pobox.com> <20030516164320.GK812@suse.de> <3EC5B7DE.4060402@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:14422
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261287AbTEQHgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 May 2003 03:36:36 -0400
In-Reply-To: <3EC5B7DE.4060402@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jens Axboe <axboe@suse.de>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

> In SAS we have a pure SCSI command set protocol (SSP),

Those are not command set protocols, they are _transport_
protocols (specific to the SAS interconnect).  (Command Set
Protocols are things like SBC, RBC, MMC, etc, i.e. ``above''
SAM-3/SPC-3.)

> a management protocol (SMP) and a protocol for tunnelling
> the ATA/PI command set/task file over an SAS link (STP)**.
> The idea is that users will be able to plug either SAS
> or SATA disks into their RAID backplanes.
> 
> So we are likely to get a SAS HBA in the SCSI subsystem
> (from Justin??) that is an initiator for those three
> protocols. How do we handle STP??

STP talks to the ATA application layer (IDE layer).
Its only (business-political) purpose is to allow SATA
over the SAS interconnect.

Overall, that'd be one complicated LLDD if it supported all three...

-- 
Luben




