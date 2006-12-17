From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6 patch] remove the broken SCSI_SEAGATE driver
Date: Sun, 17 Dec 2006 14:22:46 -0600
Message-ID: <1166386966.9647.20.camel@mulgrave.il.steeleye.com>
References: <20061212162238.GR28443@stusta.de>
	 <1165966274.5903.56.camel@mulgrave.il.steeleye.com>
	 <20061213000902.GD28443@stusta.de> <m3wt4tp9ka.fsf@defiant.localdomain>
	 <1166198454.2846.10.camel@mulgrave.il.steeleye.com>
	 <m3ac1mb88s.fsf@defiant.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60384 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751632AbWLQUYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Dec 2006 15:24:00 -0500
In-Reply-To: <m3ac1mb88s.fsf@defiant.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2006-12-17 at 21:03 +0100, Krzysztof Halasa wrote:
> James Bottomley <James.Bottomley@SteelEye.com> writes:
> 
> > I really don't see a need to declare drivers obsolete unless they bitrot
> > to the point they're demonstrably useless and no-one wants to step up to
> > fix them, which is what the BROKEN flag is for.
> 
> How do you know if the driver is broken? Especially if it still
> compiles?
> 
> Some of these things are 20 years old.

One of the touted benefits of Linux is that we run on old hardware.
Unless the driver is demonstrably wrong (and they do become so as the
APIs evolve) or it fails to compile because of bitrotting, there's no
real urgency to remove it, is there?

The reverse (how do you know if someone's still using the driver) is
equally hard to determine.

James


