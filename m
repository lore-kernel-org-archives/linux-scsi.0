From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Why is CONFIG_SCSI_QLA2X_X always enabled?
Date: 22 Apr 2004 14:56:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082660161.1778.100.camel@mulgrave>
References: <4087E95F.5050409@ihateaol.co.uk>
	<20040422092853.55d0b011.rddunlap@osdl.org>
	<1082651974.1778.52.camel@mulgrave>
	<20040422101206.70133b42.rddunlap@osdl.org>
	<1082654926.1778.84.camel@mulgrave>
	<20040422111552.5e14de00.rddunlap@osdl.org>
	<20040422113750.3ad2a065.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:22765 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264633AbUDVS4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 14:56:09 -0400
In-Reply-To: <20040422113750.3ad2a065.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: kieran@ihateaol.co.uk, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-22 at 14:37, Randy.Dunlap wrote:
> which isn't a problem by itself, as you suggest (maybe?).

Yes, it was a harmless evolutionary addition to save having a depends
SCSI && PCI on every config option in the qla2xxx/Kconfig.

However, I believe in the Kconfig language there is a way of only
sourcing the qla2xxx/Kconfig if SCSI && PCI or of making it a menu
dependent on SCSI && PCI, so the variable could be eliminated nicely
that way.

James


