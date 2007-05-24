From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 02/25] drivers/scsi/advansys.c: cleanups
Date: Wed, 23 May 2007 20:22:07 -0500
Message-ID: <1179969727.5569.69.camel@mulgrave.il.steeleye.com>
References: <200705232141.l4NLfZ1x001158@shell0.pdx.osdl.net>
	 <1179962491.5569.62.camel@mulgrave.il.steeleye.com>
	 <20070523163359.3c71f44e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50140 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755709AbXEXBWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 21:22:10 -0400
In-Reply-To: <20070523163359.3c71f44e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de

On Wed, 2007-05-23 at 16:33 -0700, Andrew Morton wrote:
> On Wed, 23 May 2007 18:21:31 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Wed, 2007-05-23 at 14:41 -0700, akpm@linux-foundation.org wrote:
> > > From: Adrian Bunk <bunk@stusta.de>
> > > 
> > > - remove the unneeded advansys.h
> > > - remove the unused advansys_setup()
> > 
> > This isn't quite right, though, is it?  advansys_setup() should be used.
> > 
> > It looks like there was a bogus conversion away from init/main.c which
> > left the function dangling.  Isn't the correct thing to do to wire it up
> > in advansys_detect() which is where it should have been in the first
> > place.
> > 
> 
> Even going back to linux-2.4.2 I can find no caller to advansys_setup(). 
> Or was its call buried in the magical template macros?

If I remember rightly, the bootsetups[] array was a 2.0 thing it became
kernel_param in 2.1.75.  It was gone by 2.4.0, so this removal thing
must have been in the 2.3 timeframe.

Still ... it can be put back .. it looks basically sound.

James




