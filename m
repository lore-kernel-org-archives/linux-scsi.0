From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Adaptec HostRAID for 7902 in 2.6 kernel series
Date: Tue, 21 Dec 2004 12:37:39 +0100
Message-ID: <1103629059.4132.6.camel@laptopd505.fenrus.org>
References: <12EA9733-52E2-11D9-B13A-0003934F6348@mac.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:40210 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261736AbULULhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2004 06:37:45 -0500
In-Reply-To: <12EA9733-52E2-11D9-B13A-0003934F6348@mac.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@mac.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2004-12-20 at 17:51 -0600, Mark Rustad wrote:
> Folks,
> 
> Is there any support for the Adaptec 7902 HostRAID operation using the 
> 2.6 kernel series? I have seen the binary modules on the Adaptec site 
> for the 2.4 kernels and I have tried various 2.6 kernels. Some of the 
> 2.6 kernels do not see the device when it is set up for HostRaid, 
> others see the underlying raw devices, which doesn't seem right.

it's actually right; hostraid is software raid, in linux the "dmraid"
tool is used to drive all such raids. I'm not sure dmraid currently
supports HostRaid, however if you contact ataraid-list@redhat.com the
people there might just be able to write a format-driver for this raid
format easily.


