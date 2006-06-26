From: Horms <horms@verge.net.au>
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization?issue fix
Date: Mon, 26 Jun 2006 18:09:15 +0900 (JST)
Message-ID: <20060626090915.CA8333402A@koto.vergenet.net>
References: <m1veqqxyrb.fsf@ebiederm.dsl.xmission.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from koto.vergenet.net ([210.128.90.7]:27320 "EHLO koto.vergenet.net")
	by vger.kernel.org with ESMTP id S1751310AbWFZJJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 05:09:16 -0400
In-Reply-To: <m1veqqxyrb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org, mike.miller@hp.com, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org, "Zou, Nanhai" <nanhai.zou@intel.com>

In article <m1veqqxyrb.fsf@ebiederm.dsl.xmission.com> you wrote:
> 
> Not all pci busses support it but there is a standard pci bus reset bit
> in pci bridges.
> 
> I don't know if it would help but it might make sense to have a config
> option that can be used to mark drivers that are known to have problems,
> in these scenarios.
> 
> CONFIG_BRITTLE_INIT perhaps?
> 
> It would at least make it easier for people to see which drivers
> they don't want to use, and give people some incentive to fix things.

I believe that MPT Fusion could go on that list.

http://permalink.gmane.org/gmane.linux.ports.ia64/14451



-- 
Horms                                           
H: http://www.vergenet.net/~horms/          W: http://www.valinux.co.jp/en/

