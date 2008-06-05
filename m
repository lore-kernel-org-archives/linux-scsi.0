From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_debug: Runtime-configurable sector size
Date: Thu, 05 Jun 2008 10:28:55 -0500
Message-ID: <1212679735.13549.35.camel@localhost.localdomain>
References: <yq18wxko6yc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55494 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYFEP3B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 11:29:01 -0400
In-Reply-To: <yq18wxko6yc.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>

On Thu, 2008-06-05 at 00:12 -0400, Martin K. Petersen wrote:
> Make scsi_debug sector size configurable at load time instead of being
> a #define.  Handy for testing 4KB sectors.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

This could have used some checkpatch love:

total: 9 errors, 2 warnings, 181 lines checked

About 8 of the errors are spaces before tab (one is the fact that
checkpatch doesn't like struct * foo, but that's the style of the file,
so I left it in).

James


