From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: relax PAGE LENGTH check for thin provisioning UNMAP support
Date: Thu, 06 May 2010 00:28:10 -0400
Message-ID: <yq1sk65ejs5.fsf@sermon.lab.mkp.net>
References: <1273096203-3164-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:65417 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0EFE3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 00:29:33 -0400
In-Reply-To: <1273096203-3164-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Wed, 5 May 2010 17:50:03 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Thin Provisioning fields are assumed available in the BLOCK LIMITS
Mike> VPD page if PAGE LENGTH is 0x3c.  The BLOCK LIMITS VPD page may be
Mike> extended over time.  Allow for the possibility that the PAGE
Mike> LENGTH exceeds 0x3c.

SBC3 states that: 

"If the device server supports thin provisioning, then the device server
shall set the PAGE LENGTH field to 3Ch."

That's a "shall".  That's a non-negotiable requirement in standards
speak.  And besides, only half of that mandated page length is currently
spoken for.  So I wonder what motivated your change?  Do you have any
examples of devices with a bigger page length?

-- 
Martin K. Petersen	Oracle Linux Engineering
