From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: dead CONFIG_ variables:  drivers/scsi/
Date: Thu, 03 May 2007 09:15:30 -0500
Message-ID: <1178201730.3714.4.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55740 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031313AbXECOPu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 10:15:50 -0400
In-Reply-To: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 2007-05-03 at 06:10 -0400, Robert P. J. Day wrote:
> $ ../dead_config.sh drivers/scsi
> ========== 53C700_BE_BUS ==========
> drivers/scsi/53c700.h:266:#ifdef CONFIG_53C700_BE_BUS

This isn't dead, it's a placeholder ... the 53c700 can be wired either
LE or BE ... there's only one current BE user, and that's a parisc box
that has to be runtime switchable (the later integrated SCSI chip was
wired LE).  However, it was thought there would be ppc users for
unconditional BE drivers.

James


