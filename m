From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sysfs host name support
Date: 09 Feb 2004 11:09:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076342962.1804.14.camel@mulgrave>
References: <20040209155046.GP3944@tpkurt.garloff.de>
	<20040209160526.A23604@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:36494 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265203AbUBIQJb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:09:31 -0500
In-Reply-To: <20040209160526.A23604@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 2004-02-09 at 11:05, Christoph Hellwig wrote:
> name is optional (you can use ->info instead), so please don't export it.
> As for proc_name vs module_name - I think we should just export one of them,
> I'm pretty open which one.  proc_name probably makes more sense.

Actually, no, I'd like to see module name as well.

We need a more generic than SCSI solution for this, I think, but if you
look at most initrd systems, they go through a lot of pattern matching
to try to translate the proc name into the module name.  This would
allow every initrd maker to eliminate those tiresome tables.

James


