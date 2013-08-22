From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 0/4] zfcp features for 3.12 merge window
Date: Thu, 22 Aug 2013 17:49:30 +0200
Message-ID: <1377186574-26954-1-git-send-email-maier@linux.vnet.ibm.com>
References: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:54857 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3HVPtp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2013 11:49:45 -0400
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 22 Aug 2013 16:43:59 +0100
In-Reply-To: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>

James,

as discussed, I split up bugfixes and features in two separate sets.
Here is a resend of zfcp features for the upcoming merge window
preparing kernel v3.12.
The patches apply on top of the current misc branch of your scsi.git.

Compared to the original posting, I had to drop the following patch for now:
 zfcp: remove access control tables interface (port leftovers)
because it only builds on top of another patch from the fixes set
 (zfcp: remove access control tables interface (keep sysfs files))
which defines a new required helper macro.
I'm going to submit the dropped patch later, once the fixes are merged upstream.

Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

