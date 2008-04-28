From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: firmware semaphore to mutex
Date: Mon, 28 Apr 2008 13:24:16 -0600
Message-ID: <20080428192416.GZ14990@parisc-linux.org>
References: <20080428174742.163523860@mvista.com> <20080428180846.GX14990@parisc-linux.org> <1209409033.12461.64.camel@localhost.localdomain> <20080428190425.GY14990@parisc-linux.org> <1209410518.12461.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59260 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966602AbYD1TYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 15:24:18 -0400
Content-Disposition: inline
In-Reply-To: <1209410518.12461.71.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Walker <dwalker@mvista.com>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Mon, Apr 28, 2008 at 12:21:58PM -0700, Daniel Walker wrote:
> Don't you need to return the -EINTR so the caller knows the nature of
> the failure? You might also need to re-factor the caller of this
> function so it properly reports the failure to userspace .. In this case
> your just returning NULL .. 

The signal is _fatal_.  Userspace doesn't get to check the return value.
It's dead.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
