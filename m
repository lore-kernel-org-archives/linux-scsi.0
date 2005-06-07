From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH RFC 0/4] use scatter lists for all block
	pc	requests	and simplify hw handlers
Date: Tue, 07 Jun 2005 12:34:57 -0400
Message-ID: <1118162097.4813.38.camel@mulgrave>
References: <007901c56b65$90f918c0$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:49334 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261950AbVFGSBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 14:01:01 -0400
In-Reply-To: <007901c56b65$90f918c0$e0019d89@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: Douglas Gilbert <dougg@torque.net>, 'Mike Christie' <michaelc@cs.wisc.edu>, 'device-mapper development' <dm-devel@redhat.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Jens Axboe' <axboe@suse.de>, LIRANS@il.ibm.com

On Tue, 2005-06-07 at 09:34 -0400, Tony Battersby wrote:
> My company (Cybernetics) sells several products that run embedded Linux
> which use the userspace scatter-gather capability of the SG driver.
> They are still running the 2.4 kernel series, but we will probably
> switch to 2.6 at some point.

What do they actually use it for?  As in why is the data scattered even
in the virtual address space?

James


