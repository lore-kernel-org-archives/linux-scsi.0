From: Andi Kleen <ak@suse.de>
Subject: Re: [Bugme-new] [Bug 7246] New: 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 2 Oct 2006 21:28:16 +0200
Message-ID: <200610022128.16237.ak@suse.de>
References: <200610021508.k92F8bmq011159@fire-2.osdl.org> <200610022035.55482.ak@suse.de> <1159815487.3460.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59056 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S965382AbWJBTfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:35:16 -0400
In-Reply-To: <1159815487.3460.36.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: adam radford <aradford@gmail.com>, Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org


> That really looks wrong ... it will fail, as we've seen for 64 bit
> platforms with no iommu.

That is just an operator error.  It's like compiling your kernel
without the driver for your root file system. Yes, CONFIG_* gives
you plenty of rope ...

> We should init the isa pool in that case. 

No.

-Andi
