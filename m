From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 02/25] drivers/scsi/advansys.c: cleanups
Date: Wed, 23 May 2007 16:33:59 -0700
Message-ID: <20070523163359.3c71f44e.akpm@linux-foundation.org>
References: <200705232141.l4NLfZ1x001158@shell0.pdx.osdl.net>
	<1179962491.5569.62.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756248AbXEWXeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 19:34:17 -0400
In-Reply-To: <1179962491.5569.62.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de

On Wed, 23 May 2007 18:21:31 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2007-05-23 at 14:41 -0700, akpm@linux-foundation.org wrote:
> > From: Adrian Bunk <bunk@stusta.de>
> > 
> > - remove the unneeded advansys.h
> > - remove the unused advansys_setup()
> 
> This isn't quite right, though, is it?  advansys_setup() should be used.
> 
> It looks like there was a bogus conversion away from init/main.c which
> left the function dangling.  Isn't the correct thing to do to wire it up
> in advansys_detect() which is where it should have been in the first
> place.
> 

Even going back to linux-2.4.2 I can find no caller to advansys_setup(). 
Or was its call buried in the magical template macros?

