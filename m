From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 13:34:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030718133404.A26784@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B0598B10@AVEXCH02.qlogic.org> <20030718122304.A23013@infradead.org> <20030718121202.GC6520@marowsky-bree.de> <20030718131352.A26546@infradead.org> <20030718122622.GD6520@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:6160 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S271718AbTGRMTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 08:19:09 -0400
Content-Disposition: inline
In-Reply-To: <20030718122622.GD6520@marowsky-bree.de>; from lmb@suse.de on Fri, Jul 18, 2003 at 02:26:22PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

On Fri, Jul 18, 2003 at 02:26:22PM +0200, Lars Marowsky-Bree wrote:
> > Given that this module never was in 2.4 I don't see clear backwards
> > compatiblity problems..
> 
> You are being very funny. No, nobody ever shipped a qlogic driver.
> Right.

So what?  Vendor ship all kinds of strange stuff and we can't really
keep the compat cruft for that around.  And the mpio stuff in qla2xxx
is _lots_ of cruft.

