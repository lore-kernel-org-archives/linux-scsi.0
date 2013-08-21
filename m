From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/8] zfcp features and bugfixes for 3.12 merge window
Date: Wed, 21 Aug 2013 08:36:06 -0700
Message-ID: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com>
References: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40288 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab3HUPgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Aug 2013 11:36:10 -0400
In-Reply-To: <1377097531-4942-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Wed, 2013-08-21 at 17:05 +0200, Steffen Maier wrote:
> James,
> 
> here is a series of zfcp features and bugfixes
> for the upcoming merge window preparing kernel v3.12.
> The patches apply on top of the current misc branch of your scsi.git.

OK, so this isn't going to work any more given Greg's recent statements.
Patches for stable have to go through the -rc fixes process, so could
you redo this as two patch sets: one for fixes with the cc stable tags
and the rest for misc?

Thanks,

James


