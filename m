From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [2.6 patch] remove the broken SCSI_SEAGATE driver
Date: Sun, 17 Dec 2006 22:18:07 +0100
Message-ID: <m3tzzu9q7k.fsf@defiant.localdomain>
References: <20061212162238.GR28443@stusta.de>
	<1165966274.5903.56.camel@mulgrave.il.steeleye.com>
	<20061213000902.GD28443@stusta.de>
	<m3wt4tp9ka.fsf@defiant.localdomain>
	<1166198454.2846.10.camel@mulgrave.il.steeleye.com>
	<m3ac1mb88s.fsf@defiant.localdomain>
	<1166386966.9647.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:40936 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbWLQVSK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 16:18:10 -0500
In-Reply-To: <1166386966.9647.20.camel@mulgrave.il.steeleye.com> (James Bottomley's message of "Sun, 17 Dec 2006 14:22:46 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> writes:

> One of the touted benefits of Linux is that we run on old hardware.
> Unless the driver is demonstrably wrong (and they do become so as the
> APIs evolve)

Sure, I expect they do - but nobody is able to check.

> The reverse (how do you know if someone's still using the driver) is
> equally hard to determine.

Sure. That's way I asked if we could make it easier.
-- 
Krzysztof Halasa
