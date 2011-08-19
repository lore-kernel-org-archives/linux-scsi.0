From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [Patch] target: remove needless include of version.h
Date: Fri, 19 Aug 2011 13:24:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108191323560.31857@swampdragon.chaosbits.net>
References: <1313736815-27234-1-git-send-email-amwang@redhat.com> <alpine.LNX.2.00.1108190906280.31857@swampdragon.chaosbits.net> <4E4E3490.5000404@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1738872377-1313753061=:31857"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26471 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1HSLXv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2011 07:23:51 -0400
In-Reply-To: <4E4E3490.5000404@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1738872377-1313753061=:31857
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 19 Aug 2011, Cong Wang wrote:

> 于 2011年08月19日 15:07, Jesper Juhl 写道:
> > On Fri, 19 Aug 2011, WANG Cong wrote:
> > 
> > > They don't version.h to be compiled. Compiling tested.
> > > 
> > 
> > Looks more or less identical to the patch I submitted on Aug 1 (and
> > earlier) : https://lkml.org/lkml/2011/8/1/309
> > 
> > 
> 
> Ah, is your patch merged?
> 

Not yet. Was planning to re-send it once more next week.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1738872377-1313753061=:31857--
