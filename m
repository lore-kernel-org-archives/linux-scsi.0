From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.9-rc3-mm3 fails to detect aic7xxx
Date: Thu, 7 Oct 2004 13:39:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041007133956.39c2427e.akpm@osdl.org>
References: <1097178019.24355.39.camel@localhost>
	<4165A369.60306@cybsft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:15818 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267890AbUJGUgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 16:36:22 -0400
In-Reply-To: <4165A369.60306@cybsft.com>
List-Id: linux-scsi@vger.kernel.org
To: "K.R. Foley" <kr@cybsft.com>
Cc: haveblue@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"K.R. Foley" <kr@cybsft.com> wrote:
>
> Dave Hansen wrote:
> > I just booted 2.6.9-rc3-mm3 and got the good ol' 
> > 
> > VFS: Cannot open root device "sda2" or unknown-block(0,0)
> > Please append a correct "root=" boot option
> > Kernel panic - not syncing: VFS: Unable to mount root fs on
> > unknown-block(0,0)
> > 
> > backing out bk-scsi.patch seems to fix it.  I believe this worked in
> > 2.6.9-rc3-mm2.
> > 
> > -- Dave
> 
> While I can't verify that backing out bk-scsi.patch fixes it for me yet, 
> I can verify that I get the exact same error trying to boot this kernel. 
> I too am using the aic7xxx.
> 

Were some earlier messages printed out, during the scsi bringup stage?

A full dmesg dump would be nice.
