From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: FW: [PATCH] 2.4.25-pre4 SCSI fusion driver
Date: Sat, 24 Jan 2004 01:32:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4011BD08.9030808@wanadoo.es>
References: <0E3FA95632D6D047BA649F95DAB60E5703A7603B@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.eresmas.com ([62.81.235.113]:31174 "EHLO
	smtp13.eresmas.com") by vger.kernel.org with ESMTP id S266817AbUAXAgZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2004 19:36:25 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703A7603B@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Gibbons, Terry" <Terry.Gibbons@lsil.com>, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>

Moore, Eric Dean wrote:

> I was involved with the CONFIG_COMPAT fix's. They were for
> I customer having a 32bit application running on x86_64.  The
> mpt driver isn't enabling the CONFIG_COMPAT define.  I tested
> this change on SuSE Sles and Redhats Rhes enterprise editions using their
> respective lastest service packs and updates, and it seemed to get enabled.
> Maybe this occured in the x86_64 branch?

CONFIG_COMPAT is _only_ in RHEL kernels.
kernel.org is *very different* from Enterprise distributions kernels.
It looks like it's for '32 bit syscall support on 64 bit kernels'

--
Software is like sex, it's better when it's bug free.

