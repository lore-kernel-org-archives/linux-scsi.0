From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] let "PCMCIA SCSI adapter support" menu depend on MODULES
Date: Thu, 4 Sep 2003 08:26:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030904082643.A26801@infradead.org>
References: <20030903232334.GL18025@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:18181 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264787AbTIDH0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2003 03:26:44 -0400
Content-Disposition: inline
In-Reply-To: <20030903232334.GL18025@fs.tum.de>; from bunk@fs.tum.de on Thu, Sep 04, 2003 at 01:23:34AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@rustcorp.com.au

On Thu, Sep 04, 2003 at 01:23:34AM +0200, Adrian Bunk wrote:
> When configuring a kernel without modules support "PCMCIA SCSI adapter 
> support" is a menu with no available items in it (all drivers depend on 
> "m").
> 
> The patch below only shows this menu when MODULES is enabled.

Not too happy with this watch although it's better than the previous
situation.  For one thing I'd get rid of the menu - we don't have menus
for PCI/ISA/MCA/whatever cards either.  Secondly these drivers probably
should work non-modular these days.

