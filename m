From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [scsi] Blacklist Traxdata CDR4120 and IOMEGA Zip drive
 to avoid lock ups.
Date: Thu, 09 Jun 2011 00:02:41 -0500
Message-ID: <1307595761.16292.489.camel@mulgrave>
References: <4DE8E76B.30301@suse.de>  <4DF05337.1020204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59495 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852Ab1FIFCo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2011 01:02:44 -0400
In-Reply-To: <4DF05337.1020204@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ankit Jain <jankit@suse.de>
Cc: linux-scsi@vger.kernel.org, werner@novell.com, Hannes Reinecke <hare@suse.de>

On Thu, 2011-06-09 at 10:29 +0530, Ankit Jain wrote:
> Ping, any feedback on this?
> 
> On 06/03/2011 07:23 PM, Ankit Jain wrote:
> > From: Werner Fink <werner@novell.com>
> > Subject: [PATCH] [scsi] Blacklist Traxdata CDR4120 and IOMEGA Zip drive to avoid lock ups.
> > 
> > This patch resulted from the discussion at
> > https://bugzilla.novell.com/show_bug.cgi?id=679277,
> > https://bugzilla.novell.com/show_bug.cgi?id=681840 .
> > 
> > Signed-off-by: Werner Fink <werner@novell.com>
> > Signed-off-by: James Bottomley <James.Bottomley@parallels.com>

That should be your signoff, please, not mine.

James


