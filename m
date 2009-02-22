From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sat, 21 Feb 2009 20:42:19 -0700
Message-ID: <20090222034219.GH2567@colo.lackof.org>
References: <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org> <499CD466.1060900@gmail.com> <m1fxi82pq0.fsf@fess.ebiederm.org> <86802c440902210031j698403cev2147e72a61e17194@mail.gmail.com> <m1r61sf9oo.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:42529 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZBVDme (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Feb 2009 22:42:34 -0500
Content-Disposition: inline
In-Reply-To: <m1r61sf9oo.fsf@fess.ebiederm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Robert Hancock <hancockrwd@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

On Sat, Feb 21, 2009 at 12:58:31AM -0800, Eric W. Biederman wrote:
...
> The difference is that there is a magic address on x86 that all MSI
> cycles are sent to.  I think it is 0xfffe0000.

arch/x86/include/asm/msidef.h:#define MSI_ADDR_BASE_LO          0xfee00000

Intel spells out the details in:
    http://www.intel.com/products/processor/manuals/index.htm

"Volume 3A: System Programming Guide, Part 1"
See chapter "9.4 LOCAL APIC"

>  In an msi to HT
> mapping capability it is necessary to program in the address to listen
> for msi packets.  That is very much an arch dependent thing.

Indeed. parisc and (AFAIK) alpha have the same ability but use completely
different address ranges depending on the chipset as well.

thanks,
grant
