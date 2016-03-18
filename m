From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: UFS V11 patch-set
Date: Fri, 18 Mar 2016 15:49:57 +0100
Message-ID: <4014649.ENvamPh3sb@wuerfel>
References: <56EBF966.8040907@synopsys.com> <56EBF9FD.9080906@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:52729 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbcCROu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2016 10:50:29 -0400
In-Reply-To: <56EBF9FD.9080906@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinayak holikatti <vinholikatti@gmail.com>, JBottomley@parallels.com, rafael.j.wysocki@intel.com, hch@lst.de, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Carlos Palminha <CARLOS.PALMINHA@synopsys.com>

On Friday 18 March 2016 12:52:13 Joao Pinto wrote:
> Hi!
> 
> Could you please check the following patch-set in order to evaluate if it is
> ready for v4.6?
> 

I think the code is ok now, but the timing apparently didn't work for 4.6.
I'd suggest you resend as soon as 4.6-rc1 is out so it can get merged into 4.7.

	Arnd
