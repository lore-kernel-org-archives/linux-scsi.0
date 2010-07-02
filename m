From: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH 10/25] scsi/sg: remove casts from void*
Date: Fri, 2 Jul 2010 11:04:54 +0400
Message-ID: <20100702070454.GA24442__14998.4953496189$1278054333$gmane$org@shinshilla>
References: <1277990204-22157-1-git-send-email-segooon@gmail.com>
 <20100701173805.GW19184@bicker>
 <20100701182724.GA22466@shinshilla>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48222 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0GBHE7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2010 03:04:59 -0400
Content-Disposition: inline
In-Reply-To: <20100701182724.GA22466@shinshilla>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, Kernel Janitors <kernel-janitors@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Andrew

On Thu, Jul 01, 2010 at 22:27 +0400, Kulikov Vasiliy wrote:
> The problem is that this driver is not even compileable.
Forget about this.
staging/wlags49_h2/wl_pci.c is not compileable, not scsi/sg.c :)
