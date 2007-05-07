From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
 boolean-values
Date: Mon, 7 May 2007 14:06:56 -0700
Message-ID: <20070507140656.3debfb55.akpm@linux-foundation.org>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
	<1178567419.3729.44.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966715AbXEGVHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 17:07:31 -0400
In-Reply-To: <1178567419.3729.44.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Mon, 07 May 2007 14:50:19 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> > From: Richard Knutsson <ricknu-0@student.ltu.se>
> > 
> > Convert:
> > FALSE -> false
> > TRUE  -> true
> 
> NAK'd by maintainer.
> 

I went back and reviewed the previous discussion.  Maintaner's reasons for
NAKing were, and remain wholly specious.

That being said, the patch is moderately wrong (or at least incomplete)
because it does things like:

-            unsigned char done = FALSE;
+            unsigned char done = false;

whereas it should have done

-            unsigned char done = FALSE;
+            bool done = false;

so I'll drop it on those grounds, not on the bogus ones.
