From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Sun, 22 Aug 2004 19:32:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3hdqvt6x2.fsf@merlin.emma.line.org>
References: <1093113450.1732.334.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:43908 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S268052AbUHVRcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 13:32:45 -0400
In-Reply-To: <1093113450.1732.334.camel@mulgrave> (James Bottomley's message
	of "21 Aug 2004 14:37:28 -0400")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> writes:

> The problems with domain validation were just the tip of the iceberg in
> the sym2 driver.  Most of its problems seem to come from an overly
> complex set of negotiating rules, which I've swept away with this patch.

> ===== drivers/scsi/sym53c8xx_2/sym_hipd.c 1.20 vs edited =====
> --- 1.20/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-08-21 09:27:03 -07:00
> +++ edited/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-08-21 11:17:09 -07:00

James,

is the patch available in a BK tree that the public can pull from?

I can't seem to get it to apply even with either or both of the patches
Matt mentioned in another thread.

Thanks in advance,

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
