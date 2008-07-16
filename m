From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 16:54:23 +0200
Message-ID: <20080716145423.GA18288@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:56217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbYGPOyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 10:54:36 -0400
Content-Disposition: inline
In-Reply-To: <1216216320.3230.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fs/compat_ioctl.c to handle CONFIG_BLOCK=n, CONFIG_SCSI=n
> to avoid build errors:

btw., this patch too solves my build problems.

  Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
