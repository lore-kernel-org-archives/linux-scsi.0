From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lkp] [ses] 3417c1b5cb: WARNING: CPU: 2 PID: 2013 at
 fs/xfs/xfs_file.c:772 xfs_file_dio_aio_write+0x2a2/0x320()
Date: Sun, 27 Dec 2015 21:19:18 -0800
Message-ID: <1451279958.2283.4.camel@HansenPartnership.com>
References: <87ziwv2vrp.fsf@yhuang-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51332 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbbL1FTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Dec 2015 00:19:20 -0500
In-Reply-To: <87ziwv2vrp.fsf@yhuang-dev.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel test robot <ying.huang@linux.intel.com>
Cc: lkp@01.org, LKML <linux-kernel@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>, "Ewan D.Milne" <emilne@redhat.com>, Andrea Gelmini <andrea.gelmini@gelma.net>, linux-scsi <linux-scsi@vger.kernel.org>

[cc to linux-scsi added]
On Mon, 2015-12-28 at 09:43 +0800, kernel test robot wrote:
> FYI, we noticed the below changes on
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git ma
> ster
> commit 3417c1b5cb1fdc10261dbed42b05cc93166a78fd ("ses: Fix problems
> with simple enclosures")
> 
> This may be the intended behavior, we found after your commit, the
> following new message appears in kernel log:
> 
> [   40.804515] scsi 8:0:12:0: Wrong diagnostic page; asked for 7 got
> 0
> 
> To reproduce:
> 
>         git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
>         cd lkp-tests
>         bin/lkp install job.yaml  # job file is attached in this
> email
>         bin/lkp run     job.yaml

OK, so what is the enclosure device at host 8?  And what happens when
you use sg_ses to ask for page 7?

James


