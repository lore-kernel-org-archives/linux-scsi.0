From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: Re: [announce] scsi_id release 0.2
Date: Fri, 12 Dec 2003 15:27:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031212152737.A1254@sygehus.dk>
References: <20031205151810.A8891@beaverton.ibm.com> <20031207153802.GA6700@suse.de> <20031207114242.A29572@beaverton.ibm.com> <20031207195915.GA6714@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a41c34.albnxx15.adsl-dhcp.tele.dk ([80.164.28.52]:1796 "EHLO
	0x50a41c34.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org with ESMTP
	id S265241AbTLLO1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 09:27:40 -0500
Content-Disposition: inline
In-Reply-To: <20031207195915.GA6714@suse.de>; from olh@suse.de on Sun, Dec 07, 2003 at 08:59:15PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Sun, Dec 07, 2003 at 08:59:15PM +0100, Olaf Hering wrote:

> I need also this patch because gcc decides that a printf("\n"); could be
> done with a putchar, which is not defined for some reasons.

#include <stdio.h>

must be missing somewhere.

-- 
Regards,
Rask Ingemann Lambertsen
