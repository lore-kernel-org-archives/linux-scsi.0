From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Sat, 10 Feb 2007 12:27:42 -0600
Message-ID: <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56229 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751713AbXBJS1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Feb 2007 13:27:46 -0500
In-Reply-To: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2007-02-10 at 18:46 +0100, Richard Knutsson wrote:
> Convert:
> FALSE -> false
> TRUE  -> true

Actually, downcasing true and false in this driver is pretty much a
retrograde step.  The reason for their being uppercased is that they
represent constants (and uppercase is the traditional defined constant
specifier).

When discussion about TRUE and FALSE came up a long time a go in the
context of the mid layer we agreed to strip the defined constants out of
that code and just go with 1 and 0 inline ... because the code was
pretty much being rewritten.  We also decided to encourage but not force
the driver writers simply to use 1 and 0 as well ... a lot of people are
deeply wedded to the TRUE and FALSE defines, it turned out.

James


