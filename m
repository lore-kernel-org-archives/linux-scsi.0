From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 18:06:37 -0600
Message-ID: <20070527000637.GB31023@colo.lackof.org>
References: <20070526191127.GB7080@colo.lackof.org> <1180209014.3712.69.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:49045 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbXE0AGp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 May 2007 20:06:45 -0400
Content-Disposition: inline
In-Reply-To: <1180209014.3712.69.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, Thibaut VARENE <T-Bone@parisc-linux.org>

On Sat, May 26, 2007 at 02:50:14PM -0500, James Bottomley wrote:
> This solution is still as wrong as it was the last three times it was
> submitted to linux-scsi:
> 
> http://marc.info/?t=117906989600001
> http://marc.info/?t=117926627700012
> http://marc.info/?t=117923062000004

ugh...sorry.  I should have looked first.

> A better, but still not quite right fix is here:
> 
> http://marc.info/?l=linux-scsi&m=117995785931981

Yes, I like this a lot better too.
But I'm failing to understanding why "late_initcall" isn't ok. 
I was expecting all drivers to have registered with scsi subsystem
in their module_init() calls and have the scans get kicked off
at that point. Further, I assumed "late_initcall" gets called
after "init" list is processed. What am I missing?

thanks,
grant
