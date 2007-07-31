From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi: fix warning in scsi_sysfs.c
Date: Tue, 31 Jul 2007 17:39:12 -0500
Message-ID: <1185921553.3468.57.camel@localhost.localdomain>
References: <200707312335.24919.lpenko@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55148 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756753AbXGaWjO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 18:39:14 -0400
In-Reply-To: <200707312335.24919.lpenko@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lado <lpenko@gmx.de>
Cc: scsi <linux-scsi@vger.kernel.org>

On Tue, 2007-07-31 at 23:35 +0200, Lado wrote:
> Subject: scsi: fix warning in scsi_sysfs.c
> 
> From: Ladislav Penko <lpenko@gmx.de>
> 
> change: trivial fix warning (removed unused variable rq)
> 
> Signed-off-by: Ladislav Penko <lpenko@gmx.de>

The trivial fixes aren't always the best.  In this case, if you set
CONFIG_BLK_DEV_BSG=y you'll find the compile breaks with this fix.  The
correct fix should already be upstream by now.

James


