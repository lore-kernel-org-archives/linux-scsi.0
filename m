From: Jens Axboe <axboe@suse.de>
Subject: Re: max GiB written per boot
Date: Tue, 7 Oct 2003 07:57:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007055714.GO972@suse.de>
References: <1064271322.4797.9.camel@patehci2> <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065474044.6835.44.camel@patehci2> <1065484077.2899.1.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:4821 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261806AbTJGF5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 01:57:18 -0400
Content-Disposition: inline
In-Reply-To: <1065484077.2899.1.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 06 2003, Pat LaVarre wrote:
> With usb2 in linux 2.6.0-test6 just now, ...
> 
> I find what works well for me is /etc/grub.conf:
> 
> title Red Hat Linux (2.6.0-test6)
>         root (hd0,8)
>         kernel /vmlinuz-2.6.0-test6 ro root=LABEL=/
>         initrd /initrd-2.6.0-test6.img
> 
> What chokes often is:
> 
> title Red Hat Linux (2.6.0-test6)
>         root (hd0,8)
>         kernel /vmlinuz-2.6.0-test6 ro root=LABEL=/ hdc=ide-scsi
>         initrd /initrd-2.6.0-test6.img
> 
> Having hdc=ide-scsi matter I think is a clue.
> 
> I don't yet know if this apparent correlation will hold up or not.

Yeah, ide-scsi is broken so you probably shouldn't be using it.

-- 
Jens Axboe

