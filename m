From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: be2iscsi: Bug Fixes Needed
Date: Sun, 17 Jan 2010 12:30:14 -0600
Message-ID: <1263753014.2802.1.camel@mulgrave.site>
References: <20100106201918.GA19887@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60702 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0AQSaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jan 2010 13:30:23 -0500
In-Reply-To: <20100106201918.GA19887@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Thu, 2010-01-07 at 01:49 +0530, Jayamohan Kallickal wrote:
> Hi James
> 
> 	These patches contains some bug fixes that are important for
> the driver.

This phraseology usually means apply to the linus kernel now.

> These patches are created using the latest scsi-misc tree and after
> applying the following patches sent earlier
> 
> http://www.spinics.net/lists/linux-scsi/msg41363.html
> http://www.spinics.net/lists/linux-scsi/msg41364.html

However, these are an enhancement stream for the kernel.

So I'm assuming these aren't essential bug fixes, but can wait until the
next merge window?  If not, they need to be made against current
upstream (because they won't apply without the updates patches).

James


