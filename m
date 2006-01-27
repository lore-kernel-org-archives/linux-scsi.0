From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: More information on scsi_cmd_cache leak... (bisect)
Date: Fri, 27 Jan 2006 16:33:54 +0300
Message-ID: <20060127133354.GA11011@mipter.zuzino.mipt.ru>
References: <200601270410.06762.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.196]:41662 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750745AbWA0NQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 08:16:07 -0500
Received: by uproxy.gmail.com with SMTP id s2so66082uge
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2006 05:16:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <200601270410.06762.chase.venters@clientec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org, a.titov@host.bg, axboe@suse.de, askernel2615@dsgml.com, jamie@audible.transient.net, neilb@suse.de

On Fri, Jan 27, 2006 at 04:09:44AM -0600, Chase Venters wrote:
> 	All bisect kernels were built from the same .config, and "make clean; make
> mrproper" was executed between each compile. (Do I really need to do that?

	git bisect {good,bad}
	make

should be enough.

First bisect steps usually result in full rebuild because some often
included header is patched.

> How does git handle timestamps? I assumed I didn't really need to but did it
> to be thorough).

