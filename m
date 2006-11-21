From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Remove #warning cruft from drivers/scsi/ips.c
Date: Tue, 21 Nov 2006 09:16:54 -0600
Message-ID: <1164122214.2808.1.camel@mulgrave.il.steeleye.com>
References: <20061121061413.5D10967BF3@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43977 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1031016AbWKUPQ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 10:16:59 -0500
In-Reply-To: <20061121061413.5D10967BF3@ozlabs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-scsi@vger.kernel.org, ipslinux@adaptec.com

On Tue, 2006-11-21 at 17:14 +1100, Michael Ellerman wrote:
> drivers/scsi/ips.c pollutes my build log telling me that it has only
> been tested on x86/ia64/x86_64. It's starting to get annoying.

Since we have a failure report for this driver on the ppc platform, I
don't necessarily see the warning as being inappropriate.

James


