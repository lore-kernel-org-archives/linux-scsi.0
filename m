From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/5] drivers/scsi/aic94xx/: replace __FUNCTION__ with
	__func__
Date: Fri, 25 Jul 2008 13:14:01 -0400
Message-ID: <1217006041.15288.13.camel@localhost.localdomain>
References: <1216954114-31949-1-git-send-email-crquan@gmail.com>
	 <20080725164253.GA7355@tree.beaverton.ibm.com>
	 <91b13c310807251008o361bc39drfb6aa227cd9fd2f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59393 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbYGYROY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2008 13:14:24 -0400
In-Reply-To: <91b13c310807251008o361bc39drfb6aa227cd9fd2f9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rae l <crquan@gmail.com>
Cc: djwong@us.ibm.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>

On Sat, 2008-07-26 at 01:08 +0800, rae l wrote:
> On Sat, Jul 26, 2008 at 12:42 AM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> > On Fri, Jul 25, 2008 at 10:48:33AM +0800, Denis ChengRq wrote:
> >> Signed-off-by: Denis ChengRq <crquan@gmail.com>
> >
> > No justification or changelog?
> I think no more explanation needed, the subject is definite.
> 
> and no justification happened here, (there are justifications otherwhere)
> 
> >> -             __FUNCTION__)
> >> +             __func__)
> >
> > include/linux/kernel.h:503:#define __FUNCTION__ (__func__)
> This solution is not completely,
> 
> >
> > I assume you're trying to kill this?
> Eventually we will need a replace in the whole tree:
> 
> grep -RsInw __FUNCTION__ . |xargs sed -i -e 's/__FUNCTION__/__func__/g'

Actually, we already have such a maintained patch by Harvey Harrison, so
we don't really need another.

Since nearly every other subsystem has done this, I was thinking we
could do it around -rc1 which should cause the minimal disruption.

James


