From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Sun, 06 Jan 2008 19:41:29 +0100
Message-ID: <478120D9.5090404@s5r6.in-berlin.de>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34641 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbYAFSnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jan 2008 13:43:24 -0500
In-Reply-To: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, peterz@infradead.org, david-b@pacbell.net, davem@davemloft.net, jarkao2@gmail.com, krh@redhat.com, dbrownell@users.sourceforge.net, James.Bottomley@HansenPartnership.com, a.zummo@towertech.it, cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org, i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net, spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org

Dave Young wrote:
> Convert semaphore to mutex in struct class.
> All the patches in this series should be applyed simultaneously

Therefore you eventually need to repost it as a single patch.  It can't
go into one of the maintainer trees otherwise, because they only take
fully bijectable patches.  (Kernel must build and run at any point in
between any patch series.)

> toc:
> ---
> 1-driver-core-struct-class-convert-semaphore-to-mutex.patch
> 2-i2c-struct-class-convert-semaphore-to-mutex.patch
> 3-ieee1394-struct-class-convert-semaphore-to-mutex.patch
> 4-power-struct-class-convert-semaphore-to-mutex.patch
> 5-rtc-struct-class-convert-semaphore-to-mutex.patch
> 6-scsi-struct-class-convert-semaphore-to-mutex.patch
> 7-spi-struct-class-convert-semaphore-to-mutex.patch

I was going to test it at runtime on top of 2.6.24-rc6, but the first
and second patch depend on stuff in -mm.  So, my laziness wins for now,
as -mm is not my cup of tea.

About your changelog:

	"xyz: convert semaphore to mutex in struct class

	Use mutex instead of semaphore in struct class.

	Signed-off-by: Dave Young <hidave.darkstar@gmail.com>"

You don't need the second line because it says the same as the first
line.  Either kill it, or replace it by an explanation _why_ the
semaphore is to be replaced by mutex.  (I guess you do it because they
are lighter-weight, both in semantics and in implementation, and because
there are better facilities to debug mutexes...)
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
