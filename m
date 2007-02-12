From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic
 boolean-values
Date: Mon, 12 Feb 2007 12:27:38 -0800
Message-ID: <20070212122738.b5e9a8af.akpm@linux-foundation.org>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
	<1171132062.3373.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965361AbXBLU1w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Feb 2007 15:27:52 -0500
In-Reply-To: <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ricknu-0@student.ltu.se, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> On Sat, 10 Feb 2007 12:27:42 -0600 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> When discussion about TRUE and FALSE came up a long time a go in the
> context of the mid layer we agreed to strip the defined constants out of
> that code and just go with 1 and 0 inline ... because the code was
> pretty much being rewritten.  We also decided to encourage but not force
> the driver writers simply to use 1 and 0 as well ... a lot of people are
> deeply wedded to the TRUE and FALSE defines, it turned out.

Given that we now have a standard kernel-wide, c99-friendly way of
expressing true and false, I'd suggest that this decision can be revisited.

Because a "true" is significantly more meaningful (and hence readable)
thing than a bare "1".
