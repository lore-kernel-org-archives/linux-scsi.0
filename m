From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Mark Workbit NinjaSCSI driver non 64bit
Date: Sun, 4 Jan 2004 00:27:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040103232718.GA6881@averell>
References: <20040101215835.GA3001@averell> <813cawsy4k.wl@omega.webmasters.gr.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p50821F3B.dip.t-dialin.net ([80.130.31.59]:24479 "EHLO
	fred.muc.de") by vger.kernel.org with ESMTP id S264318AbUACX10
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jan 2004 18:27:26 -0500
Content-Disposition: inline
In-Reply-To: <813cawsy4k.wl@omega.webmasters.gr.jp>
List-Id: linux-scsi@vger.kernel.org
To: GOTO Masanori <gotom@debian.or.jp>
Cc: Andi Kleen <ak@muc.de>, linux-scsi@vger.kernel.org, yokota@netlab.is.tsukuba.ac.jp

On Sun, Jan 04, 2004 at 03:08:59AM +0900, GOTO Masanori wrote:
> At Thu, 1 Jan 2004 22:58:35 +0100,
> Andi Kleen wrote:
> > Judging from the warnings it spews out on a 64bit compilation on AMD64
> > it is not 64bit clean.  Mark it as such in Kconfig.
> > 
> > Better would be of course to fix it.
> 
> Thanks for your report.  I compiled and exactly I saw some warnings on
> amd64 machine.  I checked all warnings, and these warnings are
> trivial, they can be easily fixed.  I attached the patch to fix
> warnings.  Nsp32 is PCI device driver, so it should also work on amd64
> architecture.

Thanks.

Did you test if it works on the AMD64 machine? Sometimes there are 64bit
issues that don't show as warnings.

-Andi
