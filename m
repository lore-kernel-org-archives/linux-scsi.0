From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Announce] Emulex LightPulse Device Driver
Date: Wed, 10 Mar 2004 13:04:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404F58A8.8040304@pobox.com>
References: <3356669BBE90C448AD4645C843E2BF2802C014D7@xbl.ma.emulex.com>	<mailman.1078908361.15239.linux-kernel2news@redhat.com> <20040310095908.33b2082f.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47761 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262736AbUCJSEj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 13:04:39 -0500
In-Reply-To: <20040310095908.33b2082f.zaitcev@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel@vger.kernel.org, James.Smart@Emulex.com, linux-scsi@vger.kernel.org

Pete Zaitcev wrote:
> Jeff Garzik <jgarzik@pobox.com> wrote:
> Flag problem on sparc is fixed by Keith Wesolowsky for 2.6.3-rcX,
> and it never existed on sparc64, which keeps CWP in a separate register.
> 
> Why it took years to resolve is that the expirience showed that
> there is no legitimate reason to pass flags as arguments. Every damn
> time it was done, the author was being stupid. Keith resolved it
> primarily because it was an unorthogonality in sparc implementation.

You would never know there were so many sparc people, until I post 
something incorrect about it.  <grin>

I stand corrected.  As someone mentioned in private, it's actually a 
shame that was fixed, since that's one less argument that can be used 
against such wrappers ;-)


>>But this bug is only an example that serves to highlight the importance 
>>of directly using Linux API functions throughout your code.  It may 
>>sound redundant, but "Linux code should look like Linux code."  This 
>>emphasis on style may sound trivial, but it's important for 
>>review-ability, long term maintenance, and as we see here, bug prevention.
> 
> 
> Yes yes yes. This is the way elx_sli_lock is harmful, not because
> of its passing flags.

Agreed.

	Jeff



