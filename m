From: Andi Kleen <ak@suse.de>
Subject: Re: [Bugme-new] [Bug 7246] New: 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 2 Oct 2006 20:35:55 +0200
Message-ID: <200610022035.55482.ak@suse.de>
References: <200610021508.k92F8bmq011159@fire-2.osdl.org> <200610022017.59697.ak@suse.de> <1159813447.3460.28.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:17571 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S965289AbWJBSgB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 14:36:01 -0400
In-Reply-To: <1159813447.3460.28.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: adam radford <aradford@gmail.com>, Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Monday 02 October 2006 20:24, James Bottomley wrote:
> On Mon, 2006-10-02 at 20:17 +0200, Andi Kleen wrote:
> > nommu_* means he didn't compile in the IOMMU code.
> > 
> > Operator error -> invalid.
> 
> But how did we get sg segments over the mask?  The block layer should
> have bounced them, I think.

Yes, but it can't when the bounce code is not compiled in.
In this case it just printks and you saw those printks.

-Andi

