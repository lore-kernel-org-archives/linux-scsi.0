From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Fri, 21 Oct 2005 10:16:30 +0200
Message-ID: <1129882591.2786.9.camel@laptopd505.fenrus.org>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>
	 <20051020170330.GA16458@lst.de>
	 <1129828959.2807.18.camel@laptopd505.fenrus.org>
	 <4357F9D0.3090602@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60067 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932114AbVJUIQg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 04:16:36 -0400
In-Reply-To: <4357F9D0.3090602@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, jejb@steeleye.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Thu, 2005-10-20 at 16:10 -0400, Luben Tuikov wrote:
> You see?  You don't need IOCTLs, yet you can be fully compliant
> to the spec so that already existing user space management programs
> can transition with minimal change to their code (over to the front
> end: sg/whatever). 

this is EXACTLY my point.  A proper API would NOT need the userland apps
to change if the underlying mechanism changes. Or in other words: today
it may be SG, tomorrow BSG or SysFS, and when we open 2.7 the mechanism
may be WokkieWokkie. The implementation of the interface library may
need to change for this, but the management app should not. 

There is a parallel in the glibc/posix/sus world: With the 2.6 kernel
there is a new syscall mechanism (sysenter) on x86 kernels available.
NONE of the applications needed changing, fopen() remained fopen(), not
just as API but also as ABI. All that needed some adjustments were glibc
internals.

