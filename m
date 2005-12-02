From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi kexec fix
Date: Fri, 2 Dec 2005 13:28:20 -0600
Message-ID: <20051202192820.GA10115@cs.umn.edu>
References: <20051115155300.GA26724@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.202]:33480 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1750777AbVLBT2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2005 14:28:22 -0500
Content-Disposition: inline
In-Reply-To: <20051115155300.GA26724@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>

On Tue, Nov 15, 2005 at 09:53:00AM -0600, Dave C Boutcher wrote:
> James, this is a 2.6.15 candidate...it makes ibmvscsi work
> correctly with the recent set of kexec patches that went in.
> This is based on work by Michael Ellerman, who chased this
> initially.  He validated that it works during kexec.
> 
> Handle kexec correctly in ibmvscsi.   During kexec the adapter
> will not get cleaned up correctly, so we may need to reset it
> to make it sane again.
> 
> Signed-off-by: Dave Boutcher <sleddog@us.ibm.com>

James, if this doesn't make it into 2.6.15 it won't totally break
my heart, since I'm not sure how many people are using ppc64
kexec, but was there some reason this patch wasn't included in 
your 2.6.15 fixes?

-- 
Dave Boutcher
