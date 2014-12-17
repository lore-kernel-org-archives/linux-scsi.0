From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4 v3] scsi:stex.c Add reboot support
Date: Wed, 17 Dec 2014 01:30:27 -0800
Message-ID: <20141217093027.GA13198@infradead.org>
References: <548FCD81.7030106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaLQJaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 04:30:39 -0500
Content-Disposition: inline
In-Reply-To: <548FCD81.7030106@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>, ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I'm not going to add a new reboot notifier for a driver.  If you can
convince the driver model / PM people to pass this information to
->shutdown we can add support for this difference, but not in this way.

Can you send me a series that just adds the hardware support for now, so
we can dash this PM issue out separately?

