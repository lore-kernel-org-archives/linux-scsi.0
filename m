From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Tue, 4 Dec 2007 09:36:40 -0600 (CST)
Message-ID: <20071204153641.2938DDBA2@gherkin.frus.com>
References: <20071204121618.GA26132@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:56457 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbXLDPgx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 10:36:53 -0500
In-Reply-To: <20071204121618.GA26132@elte.hu> "from Ingo Molnar at Dec 4, 2007
 01:16:18 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Cree <mcree@orcon.net.nz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>

Ingo Molnar wrote:
> once you are done with the download of the initial cloned git repository 
> (which is 200MB+), all the bisection steps will be local and you'll be 
> only limited by kernel rebuild speed and by bootup and testing speed, 
> not by network bandwidth.

ACK.  Have tested two kernels in the past 24 hours, and the third is
building as I type this.  The builds seem to be taking about 3 hours
each.  First two tests good, so the offending commit is somewhere in
the last 25% (roughly) of the changes between -rc2 and -rc3: git says
82 revisions left to test.  Might have this painted into a corner in
the next day or so.  I'll try to be quick about it, since -rc4 is out.

> ( once you have the cloned repository i'd suggest for you to keep it - 
>   that way you can track susequent kernels via "git-pull" and it uses a 
>   very network-efficient delta protocol. )

Will do...  I'm in the fortunate position of having enough disk space
on my Alpha that I can maintain multiple trees for this kind of effort.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
