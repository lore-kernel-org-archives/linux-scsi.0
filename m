From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 2/4] Documentation: Add documentation for APM X-Gene SoC SATA host controller DTS binding
Date: Wed, 15 Jan 2014 21:10:33 +0100
Message-ID: <5905127.tqJ3nFt5cj@wuerfel>
References: <1389769910-15505-1-git-send-email-lho@apm.com> <20140115111839.GB25824@e106331-lin.cambridge.arm.com> <CAPw-ZT=wJVQ2Qw47Ehgu6rJZ4HkpADrGuhZr8Yjf4XA6z+-xbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaAOUKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 15:10:53 -0500
In-Reply-To: <CAPw-ZT=wJVQ2Qw47Ehgu6rJZ4HkpADrGuhZr8Yjf4XA6z+-xbA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "olof@lixom.net" <olof@lixom.net>, "tj@kernel.org" <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Wednesday 15 January 2014 12:04:02 Loc Ho wrote:
> 
> >> +- clocks             : Reference to the clock entry.
> >> +- phys                       : PHY reference with parameter 0.
> >
> > The specific value of the phy-specifier shouldn't matter to this
> > binding. What should matter is what it logically corresponds to.
> 
> I not quite following this. Are you suggest that I drop the value 0.
> In the binding, one needs to specify the mode of operation - 0 is for
> SATA. Can you explain more?

The SATA device should not care what the argument for the PHY
device is. You could connect the same device to another PHY
that has a different set of arguments, which is the whole point
of abstracting it.

	Arnd
