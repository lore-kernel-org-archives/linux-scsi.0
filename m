From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/82] remove linux/version.h from drivers/message/fus ion
Date: Wed, 13 Jul 2005 15:37:42 +0100
Message-ID: <20050713143742.GB26025@infradead.org>
References: <91888D455306F94EBD4D168954A9457C030A908F@nacos172.co.lsil.com> <20050713021648.GA23118@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28812 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262667AbVGMOh5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 10:37:57 -0400
Content-Disposition: inline
In-Reply-To: <20050713021648.GA23118@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

> In general, this construct:
> 
> > > -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
> > > -static int inline scsi_device_online(struct scsi_device *sdev)
> > > -{
> > > -	return sdev->online;
> > > -}
> > > -#endif
> 
> is better tested as:
> 
> #ifndef scsi_device_inline
> static int inline scsi_device_online(struct scsi_device *sdev)
> {
>     return sdev->online;
> }
> #endif

Even better fusion should stop using this function because doing so
is broken.. We tried that long ago but it got stuck somewhere.

