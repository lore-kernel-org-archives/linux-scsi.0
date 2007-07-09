From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Mon, 9 Jul 2007 19:36:04 +0000
Message-ID: <20070709193603.GA5722@ucw.cz>
References: <20070705194909.337398431@intel.com> <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1591 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761371AbXGKNNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 09:13:55 -0400
Content-Disposition: inline
In-Reply-To: <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

Hi!

> This patch will modify the scsi subsystem to allow
> users to set a power management policy for the link.
> 
> The scsi subsystem will create a new sysfs file for each
> host in /sys/class/scsi_host called "link_power_management_policy".
> This file can have 3 possible values:
> 
> Value		Meaning
> -------------------------------------------------------------------
> min_power	User wishes the link to conserve power as much as
> 		possible, even at the cost of some performance
> 
> max_performance User wants priority to be on performance, not power
> 		savings
> 
> medium_power	User wants power savings, with less performance cost
> 		than min_power (but less power savings as well).

Has that anything to do with HIPM vs. DIPM? 

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
