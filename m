From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Unification of the SCSI Kconfig menus
Date: Fri, 30 May 2003 14:14:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030530141451.A9352@infradead.org>
References: <20030530125318.GK28581@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:52754 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263637AbTE3NBd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 09:01:33 -0400
Content-Disposition: inline
In-Reply-To: <20030530125318.GK28581@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Fri, May 30, 2003 at 01:53:18PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>

On Fri, May 30, 2003 at 01:53:18PM +0100, Matthew Wilcox wrote:
> I think it would be useful to split the existing drivers/scsi/Kconfig into
> drivers/scsi/Kconfig_core and drivers/scsi/Kconfig_drivers.  That allows
> um to use Kconfig_core without using the drivers.

You should be using the drivers for everything even if that means adding
the missing bus depencies.

