From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] qla2xxx: firmware semaphore to mutex
Date: Mon, 28 Apr 2008 21:33:34 +0200
Message-ID: <20080428193334.GD9907@elte.hu>
References: <20080428174742.163523860@mvista.com> <20080428180846.GX14990@parisc-linux.org> <1209409033.12461.64.camel@localhost.localdomain> <20080428190425.GY14990@parisc-linux.org> <1209410518.12461.71.camel@localhost.localdomain> <20080428192416.GZ14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:46372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966892AbYD1Te2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 15:34:28 -0400
Content-Disposition: inline
In-Reply-To: <20080428192416.GZ14990@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Daniel Walker <dwalker@mvista.com>, James.Bottomley@HansenPartnership.com, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Mon, Apr 28, 2008 at 12:21:58PM -0700, Daniel Walker wrote:
> > Don't you need to return the -EINTR so the caller knows the nature of
> > the failure? You might also need to re-factor the caller of this
> > function so it properly reports the failure to userspace .. In this case
> > your just returning NULL .. 
> 
> The signal is _fatal_.  Userspace doesn't get to check the return 
> value. It's dead.

i agree with your change, nevertheless Daniel is right in that the 
change should be in a separate patch. "sem2mutex" patches are supposed 
to be NOP-ish patches, with nothing else mixed in.

	Ingo
