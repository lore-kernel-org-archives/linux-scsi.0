From: Greg KH <greg@kroah.com>
Subject: Re: [ANNOUNCE 2/6] Linux-iSCSI High-Performance Initiator
Date: Mon, 11 Apr 2005 22:34:15 -0700
Message-ID: <20050412053415.GD32372@kroah.com>
References: <425B3F58.2040000@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:45007 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262022AbVDLFem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 01:34:42 -0400
Content-Disposition: inline
In-Reply-To: <425B3F58.2040000@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> +struct iscsi_hdr {
> +	uint8_t		opcode;
> +	uint8_t		flags;		/* Final bit */
> +	uint8_t		rsvd2[2];
> +	uint8_t		hlength;	/* AHSs total length */
> +	uint8_t		dlength[3];	/* Data length */
> +	uint8_t		lun[8];
> +	uint32_t	itt;		/* Initiator Task Tag */
> +	uint32_t	ttt;		/* Target Task Tag */
> +	uint32_t	statsn;
> +	uint32_t	exp_statsn;
> +	uint8_t		other[16];

Please use u8 and u32 instead of the types you used here.  See the lkml
archives for many threads about this topic.

thanks,

greg k-h
