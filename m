From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 7246] New: 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 02 Oct 2006 13:24:07 -0500
Message-ID: <1159813447.3460.28.camel@mulgrave.il.steeleye.com>
References: <200610021508.k92F8bmq011159@fire-2.osdl.org>
	 <20061002105733.a9e82ddf.akpm@osdl.org>
	 <b1bc6a000610021106gab7efe7jcbab275b5030db9e@mail.gmail.com>
	 <200610022017.59697.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:44687 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965237AbWJBSYS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 14:24:18 -0400
In-Reply-To: <200610022017.59697.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: adam radford <aradford@gmail.com>, Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2006-10-02 at 20:17 +0200, Andi Kleen wrote:
> nommu_* means he didn't compile in the IOMMU code.
> 
> Operator error -> invalid.

But how did we get sg segments over the mask?  The block layer should
have bounced them, I think.

James


