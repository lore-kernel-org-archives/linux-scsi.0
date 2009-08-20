From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: oops during scsi scanning disk setup
Date: Thu, 20 Aug 2009 16:26:01 -0600
Message-ID: <1250807161.4302.167.camel@mulgrave.site>
References: <20090820180549.GD7542@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZHTW0G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 18:26:06 -0400
In-Reply-To: <20090820180549.GD7542@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-08-20 at 19:05 +0100, Chris Webb wrote:
>   15:27:13.014 kernel: IP: [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd

Have to confess, no idea how this happened.  Especially since the system
must have gone through the disk iterator once before successfully.

Can you use addr2line or gdb to get where this occurred?

Thanks,

James


