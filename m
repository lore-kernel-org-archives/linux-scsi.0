From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [summary] state of scsi drivers
Date: Wed, 14 Jan 2004 23:10:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114230525.T74136@quaver.in1.lcl>
References: <4005D4B4.1000705@wanadoo.es>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com ([192.67.166.79]:47881 "EHLO beppo.feral.com")
	by vger.kernel.org with ESMTP id S264415AbUAOHKM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 02:10:12 -0500
In-Reply-To: <4005D4B4.1000705@wanadoo.es>
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


> o feral_isp
>    manufacturer: QLOGIC
>    kernel: -
>    latest: Linux Platform 2.1 Common Core Code 2.7 (13 Nov 2003)
>    arch: i386 alpha sparc powerpc
>    features:
>    maintainer: external <mjacob*AT*feral.com>
>    url: http://www.feral.com/isp.html

Also bk://bitkeeper.feral.com:9002.

I've pretty much not had any job context and/or time to move this into
2.6. It seems that Andrew's work is getting lots of good review and
is improving and has the full support of the h/w vendor.

I'm actively maintaining this driver, but the context is more in
relation to target mode support for Quantum these days, which is lucky
if it's newer than a 2.4.20 kernel (and 2.2.6 or some darned thing for
PowerPC).

Unless there's a great demand for it, it's not clear whether this
driver will make it into 2.6. I'd really have to get a job context and a
refresh of some of the newer h/w to be able to do this.

But thanks for noting it- it's been a fun project over the years.




