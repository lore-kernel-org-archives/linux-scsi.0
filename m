From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 4/6] aic79xx: Sanitize inb / outb handling
Date: Thu, 22 Dec 2005 14:57:19 -0500
Message-ID: <43AB051F.8020508@pobox.com>
References: <43AAB695.6030808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:14779 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965165AbVLVT5Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 14:57:25 -0500
In-Reply-To: <43AAB695.6030808@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> This patches coalesces inb/outb calls to the approriate word or long form.

Are all paths tested, or at least verified with documentation?

Sometimes hardware will fault/crash/lock if the proper byte enable isn't 
used...

	Jeff


