From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [scsi:for-next 22/23] ERROR: "__udivdi3" [drivers/scsi/sg.ko]
 undefined!
Date: Thu, 5 Nov 2015 10:31:42 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1511051025320.25468-100000@netrider.rowland.org>
References: <201511051357.REEEWoIk%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:39340 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161679AbbKEPbn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 10:31:43 -0500
In-Reply-To: <201511051357.REEEWoIk%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Odin.com>

On Thu, 5 Nov 2015, kbuild test robot wrote:

> Hi Alan,
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> head:   a34a7cb8a7905606206559cd8d6605e5a72028e9
> commit: b704f70ce2003c8046d5c0128303aeeb0d93d890 [22/23] SCSI: fix bug in scsi_dev_info_list matching
> config: i386-randconfig-s0-201544 (attached as .config)
> reproduce:
>         git checkout b704f70ce2003c8046d5c0128303aeeb0d93d890
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> Note: the scsi/for-next HEAD 5575a6ea316b3fa80dc316083c3fac59743ae1db builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
> >> ERROR: "__udivdi3" [drivers/scsi/sg.ko] undefined!
> >> ERROR: "__umoddi3" [drivers/scsi/sg.ko] undefined!

It's hard to see how this commit could be the cause of that error.  
The commit doesn't touch any of the files involved in building the sg
module; in fact, all its changes are confined to a single function that
isn't part of sg.c.

Are you sure this is really the first bad commit?

Alan Stern

