From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 3/3] zfcp: remove access control tables interface
 (keep sysfs files)
Date: Thu, 22 Aug 2013 09:30:37 -0700
Message-ID: <1377189037.2009.14.camel@dabdike.int.hansenpartnership.com>
References: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com>
	 <1377186338-35344-1-git-send-email-maier@linux.vnet.ibm.com>
	 <1377186338-35344-4-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45625 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab3HVQaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Aug 2013 12:30:39 -0400
In-Reply-To: <1377186338-35344-4-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

On Thu, 2013-08-22 at 17:45 +0200, Steffen Maier wrote:
> From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> 
> By popular demand, this patch brings back a couple of sysfs attributes
> removed by commit 663e0890e31cb85f0cca5ac1faaee0d2d52880b5
> "[SCSI] zfcp: remove access control tables interface".
> The content has been irrelevant for years, but the files must be
> there forever for whatever user space tools that may rely on them.
> 
> Since these files always return a constant value, a new stripped
> down show-macro was required. Otherwise build warnings would have
> been introduced.
> 
> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org #3.11+

If I'm sending this for 3.11-rc, this stable tag is unnecessary, right?
It will go into 3.11 and you don't want it for 3.10.

James


