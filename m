From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1 of 1] cciss: add procfs interface to rescan logical
 volumes
Date: Tue, 7 Oct 2008 09:35:30 -0700
Message-ID: <20081007093530.1793a81b@infradead.org>
References: <20081007162454.GA12104@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbYJGQff (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 12:35:35 -0400
In-Reply-To: <20081007162454.GA12104@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, JensAxboejens.axboe@oracle.com, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

On Tue, 7 Oct 2008 11:24:54 -0500
Mike Miller <mike.miller@hp.com> wrote:

> Patch 1 of 1
> 
> This patch adds a procfs interface so users can force a rescan of the
> logical volumes attached to the controller. A new product uses Target
> Based Management (TBM) out-of-band for configuration purposes. With
> this method the driver has no way of knowing that something has
> changed, i.e., new logical volume(s) added or existing volumes
> deleted. This interface allows the user to echo "rescan volumes" >
> /proc/driver/cciss/ccissN to force the driver to rebuild our table of
> logical volumes. 
> Please consider this patch for inclusion.


I'll ask the obvious question (since you didn't address this)...
why is this a proc thing and not just a sysfs attribute of the device?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
