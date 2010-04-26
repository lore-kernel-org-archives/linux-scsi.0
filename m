From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: virtual_gb ignores sector_size
Date: Mon, 26 Apr 2010 10:44:19 -0400
Message-ID: <yq14oiye0jg.fsf@sermon.lab.mkp.net>
References: <4BD419BF.4040109@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:52227 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0DZOo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2010 10:44:59 -0400
In-Reply-To: <4BD419BF.4040109@interlog.com> (Douglas Gilbert's message of
	"Sun, 25 Apr 2010 12:30:23 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> In the scsi_debug driver, the virtual_gb option ignores the
Doug> sector_size, implicitly assuming that is 512 bytes.  So if
Doug> 'virtual_gb=1 sector_size=4096' the result is an 8 GB (virtual)
Doug> disk.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>


James: We've got quite a few unmerged scsi_debug changes out there right
now.  Are you keeping track??

-- 
Martin K. Petersen	Oracle Linux Engineering
