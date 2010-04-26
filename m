From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi_debug: virtual_gb ignores sector_size
Date: Mon, 26 Apr 2010 09:46:07 -0500
Message-ID: <1272293167.4497.57.camel@mulgrave.site>
References: <4BD419BF.4040109@interlog.com>
	 <yq14oiye0jg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab0DZOqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Apr 2010 10:46:13 -0400
In-Reply-To: <yq14oiye0jg.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2010-04-26 at 10:44 -0400, Martin K. Petersen wrote:
> >>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:
> 
> Doug> In the scsi_debug driver, the virtual_gb option ignores the
> Doug> sector_size, implicitly assuming that is 512 bytes.  So if
> Doug> 'virtual_gb=1 sector_size=4096' the result is an 8 GB (virtual)
> Doug> disk.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> 
> James: We've got quite a few unmerged scsi_debug changes out there right
> now.  Are you keeping track??

Yes, but unless I missed something, Doug is still the maintainer, so I'm
waiting for his testing and ack on some of the ones you submitted.

James


