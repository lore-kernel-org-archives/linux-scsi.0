From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Thu, 6 Nov 2003 18:55:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031106185511.C15403@devserv.devel.redhat.com>
References: <B179AE41C1147041AA1121F44614F0B0598CE5@AVEXCH02.qlogic.org> <20031106171409.GN437@suse.de> <1068140592.5234.8.camel@laptop.fenrus.com> <20031106175032.GO437@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:46013 "EHLO
	devserv.devel.redhat.com") by vger.kernel.org with ESMTP
	id S263816AbTKFRzc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 12:55:32 -0500
Content-Disposition: inline
In-Reply-To: <20031106175032.GO437@suse.de>; from axboe@suse.de on Thu, Nov 06, 2003 at 06:50:32PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Arjan van de Ven <arjanv@redhat.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Anderson <andmike@us.ibm.com>, Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>


On Thu, Nov 06, 2003 at 06:50:32PM +0100, Jens Axboe wrote:
> drive it is not). Now both 2.4 and 2.6 make that guarentee. The only
> argument for disabling clustering would be for 2.4 for CPU cycle
> reasons.

yep; on 2.4 it's rather visible in the profiles during some benchmark
test I did (like 5% of total CPU cycles)
