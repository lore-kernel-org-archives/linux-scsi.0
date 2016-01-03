From: Christoph Hellwig <hch@lst.de>
Subject: Re: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
	[kworker/1:1:29]
Date: Sun, 3 Jan 2016 12:46:28 +0100
Message-ID: <20160103114628.GA10582@lst.de>
References: <20151217222737.00000ab6@localhost> <20151231180415.00000bfc@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60107 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbcACLq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jan 2016 06:46:29 -0500
Content-Disposition: inline
In-Reply-To: <20151231180415.00000bfc@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Dec 31, 2015 at 06:04:15PM +0100, Sebastian Herbszt wrote:
> I still get this on 4.4.0-rc7-1.g276c9f4-default. Since this did not
> happen on 4.3 I checked the scsi changes and found the following commit:
> 
> scsi: restart list search after unlock in scsi_remove_target
> 
> Christoph, can it cause this issue?

Apparently yes.  Bad hard a patch to avoid this when he resubmitted
my patch, which for some reason didn't get apply.  Can you grab it
from the list archives and give it a try?
