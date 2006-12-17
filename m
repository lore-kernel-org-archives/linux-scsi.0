From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [2.6 patch] remove the broken SCSI_SEAGATE driver
Date: Sun, 17 Dec 2006 21:03:15 +0100
Message-ID: <m3ac1mb88s.fsf@defiant.localdomain>
References: <20061212162238.GR28443@stusta.de>
	<1165966274.5903.56.camel@mulgrave.il.steeleye.com>
	<20061213000902.GD28443@stusta.de>
	<m3wt4tp9ka.fsf@defiant.localdomain>
	<1166198454.2846.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:36589 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbWLQUDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 15:03:17 -0500
In-Reply-To: <1166198454.2846.10.camel@mulgrave.il.steeleye.com> (James Bottomley's message of "Fri, 15 Dec 2006 10:00:54 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> writes:

> I really don't see a need to declare drivers obsolete unless they bitrot
> to the point they're demonstrably useless and no-one wants to step up to
> fix them, which is what the BROKEN flag is for.

How do you know if the driver is broken? Especially if it still
compiles?

Some of these things are 20 years old.
-- 
Krzysztof Halasa
