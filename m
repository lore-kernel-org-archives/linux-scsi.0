From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Wed, 22 Feb 2006 15:36:47 -0600
Message-ID: <1140644207.6616.15.camel@mulgrave.il.steeleye.com>
References: <8C064C48AB104B428CBA524C342357CA324AE4@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:35742 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751465AbWBVVg4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 16:36:56 -0500
In-Reply-To: <8C064C48AB104B428CBA524C342357CA324AE4@aime2k05.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org, Tarte@us.ibm.com, Jeff Garzik <jgarzik@redhat.com>

On Wed, 2006-02-22 at 13:24 -0800, Tarte, Robert wrote:
> What model ia64 are you running James?  I'll see if Adaptec has one to
> try to help reproduce this issue.  Jeff, have you tried the fixes to see
> if they addressed the issues you were seeing (OCM error when BIOS off
> and booted off of SCSI)?

This is a HP zx2000 ... small desktop single CPU ia64 (itanic) with the
standard HP ZX1 IOMMU system.

James


