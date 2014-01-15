From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 2/4] Documentation: Add documentation for APM X-Gene SoC SATA host controller DTS binding
Date: Wed, 15 Jan 2014 22:12:17 +0100
Message-ID: <4632602.a1zUZOeMuh@wuerfel>
References: <1389769910-15505-1-git-send-email-lho@apm.com> <5905127.tqJ3nFt5cj@wuerfel> <CAPw-ZTmVYfPLUVmtes3Gn8Z=+gyFtLoZxc-QUdHH7-ePjKAG9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAOVNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:13:08 -0500
In-Reply-To: <CAPw-ZTmVYfPLUVmtes3Gn8Z=+gyFtLoZxc-QUdHH7-ePjKAG9A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Loc Ho <lho@apm.com>, Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, "tj@kernel.org" <tj@kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, Tuan Phan <tphan@apm.com>

On Wednesday 15 January 2014 13:08:47 Loc Ho wrote:
> >> >> +- clocks             : Reference to the clock entry.
> >> >> +- phys                       : PHY reference with parameter 0.
> >> >
> >> > The specific value of the phy-specifier shouldn't matter to this
> >> > binding. What should matter is what it logically corresponds to.
> >>
> >> I not quite following this. Are you suggest that I drop the value 0.
> >> In the binding, one needs to specify the mode of operation - 0 is for
> >> SATA. Can you explain more?
> >
> > The SATA device should not care what the argument for the PHY
> > device is. You could connect the same device to another PHY
> > that has a different set of arguments, which is the whole point
> > of abstracting it.
> >
> 
> I understand what you wrote here. We should not have an argument from
> the host controller. Then my question is how should the PHY node
> indicates that it needs to be configured itself as an SATA PHY?

The "phys" property should specify whatever the configuration of
the phy device is supposed to be. It's just not the business of
the sata driver or the sata binding to know what that configuration
is.

	Arnd
