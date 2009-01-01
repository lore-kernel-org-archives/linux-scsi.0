From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Thu, 01 Jan 2009 15:33:06 +0200
Message-ID: <495CC612.30800@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com> <20081231112515.2d790d1c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:11678 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755974AbZAANdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2009 08:33:15 -0500
In-Reply-To: <20081231112515.2d790d1c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

Andrew Morton wrote:
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>> When, if, all is fixed, through which tree/maintainer can exofs be submitted?
> 
> I can merge them.  Or you can run a git tree of your own, add it to
> linux-next and ask Linus to pull it at the appropriate time.
> 

Hi James

Andrew suggested that maybe I should push exofs file system directly to
Linus as it is pretty orthogonal to any other work. Sitting in linux-next
will quickly expose any advancements in VFS and will force me to keep
the tree uptodate.

If that is so, and is accepted by Linus, would you rather that also the
open-osd initiator library will be submitted through the same tree?
The conflicts with scsi are very very narrow. The only real dependency
is the ULD being a SCSI ULD. I will routinely ask your ACK on any scsi 
or ULD related patches. Which are very few. This way it will be easier
to manage the dependencies between the OSD work, the OSD pNFS-Objects
trees at pNFS project, and the pNFSD+EXOFS export. One less dependency.

[I already have such a public tree at git.open-osd.org for a while now]

Thanks
Boaz
 
