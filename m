From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Patches for SCSI scanning
Date: 18 Apr 2004 18:16:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082330192.1969.37.camel@mulgrave>
References: <20040418185751.GC4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:33977 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264207AbUDRXQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 19:16:37 -0400
In-Reply-To: <20040418185751.GC4868@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, 2004-04-18 at 13:57, Kurt Garloff wrote:
> An alternative to the blacklist is to offer boot/module parameters
> again. This is what the following series of 6 patches do.
> Most don't really depend on each other, but they'll only apply
> cleanly in the order sent.
> 
> I did not yet compare our 2.4 blacklist with the 2.6 one; I'll
> port our additional 2.4 entries to 2.6 soon.

Erm, Kurt, we already have a module load time parameter for altering
both blacklist entries and scanning defaults.

It's dev_flags and default_dev_flags in scsi_devinfo.c

Could you first explain why you can't use this existing infrastructure?

Thanks,

James


