From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Mon, 23 May 2005 15:41:15 -0500
Message-ID: <1116880875.5021.34.camel@mulgrave>
References: <20050523201535.GA24298@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18374 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261954AbVEWUlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 16:41:25 -0400
In-Reply-To: <20050523201535.GA24298@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Mon, 2005-05-23 at 16:15 -0400, Jeff Garzik wrote:
> Patch is via Mark Lord, 

Um, it is? it looks identical to this one from Jens (down to the
gratuitous style corrections)

http://marc.theaimsgroup.com/?t=111409327100001

However, before anything happens I'd like to get the SCSI pieces
correct.  The thread petered out before a resolution, however, I think
at least disk devices should be doing a synchronize cache on suspend.

James


