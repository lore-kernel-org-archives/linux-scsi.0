From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: Problems building 2.6.26 and 2.6.27-rc1
Date: Wed, 30 Jul 2008 20:07:28 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3E811B0@GVW0547EXC.americas.hpqcorp.net>
References: <20080730184833.GA936@roadking.ldev.net>
 <adaiqunyyxd.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12310 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbYG3UIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 16:08:10 -0400
In-Reply-To: <adaiqunyyxd.fsf@cisco.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Roland wrote:

>
>  > I'm getting the following error when trying to build
> either 2.6.26 or  > 2.6.27-rc1:
>  >
>  > arch/x86/kernel/head64.c: In function 'x86_64_start_kernel':
>  > arch/x86/kernel/head64.c:88: error: size of array 'type
> name' is negative
>
> It looks like you're hitting
>
>         BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
>
> No idea why you're hitting that though.  What's your .config
> and compiler?
>
I think maybe I've figured out what's breaking my build. If use "make -jN" I hit the error. I usually set N to the number of processors (real and HT). So if /proc/cpuinfo display info about 4 processors I use -j4, etc. If I don't specify the number of jobs to run simultaneously the build completes with just the usual warnings.

Any experts on parallelism out there?

-- mikem
