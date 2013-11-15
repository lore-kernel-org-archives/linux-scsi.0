From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
Date: Fri, 15 Nov 2013 13:52:33 +0100
Message-ID: <201311151352.33803.arnd@arndb.de>
References: <1384457519-21335-1-git-send-email-lho@apm.com> <1384457519-21335-2-git-send-email-lho@apm.com> <201311151335.09577.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3KOMwm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2013 07:52:42 -0500
In-Reply-To: <201311151335.09577.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Friday 15 November 2013, Arnd Bergmann wrote:
> On Thursday 14 November 2013, Loc Ho wrote:
> > +- id                   : PHY ID (0 = first, 1 = second, 2 = third)
> > +- #phy-cells           : Shall be 0
> 
> Hmm, it seems like this would make more sense if you have #phy-cells=<1>
> and have the PHY ID in user node as the argument.

Ignore this comment. After reading patch 2, I concluded that your choice of
#phy-cells=0 is probably more appropriate here.

	Arnd
