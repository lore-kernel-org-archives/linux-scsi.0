From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sysfs host name support
Date: Mon, 9 Feb 2004 16:05:27 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209160526.A23604@infradead.org>
References: <20040209155046.GP3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:56848 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262902AbUBIQF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:05:29 -0500
Content-Disposition: inline
In-Reply-To: <20040209155046.GP3944@tpkurt.garloff.de>; from garloff@suse.de on Mon, Feb 09, 2004 at 04:50:46PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Mon, Feb 09, 2004 at 04:50:46PM +0100, Kurt Garloff wrote:
> Please apply the attached patch.
> It exports the 3 names to sysfs under /sys/classes/scsi_hosts/hostX/
> name, proc_name, module_name.

name is optional (you can use ->info instead), so please don't export it.
As for proc_name vs module_name - I think we should just export one of them,
I'm pretty open which one.  proc_name probably makes more sense.

> +shost_rd_attr2(module_name, hostt->module->name, "%s\n");

How does this work for builtin modules?  Last time I checked hostt->module
was NULL for those.

