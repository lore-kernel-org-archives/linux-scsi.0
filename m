From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [patch] [SCSI] dc395x: uninitialized variable in device_alloc()
Date: Wed, 13 Feb 2013 13:06:24 +0100
Message-ID: <3015897.zxxipoZ9rM@linux-5eaq.site>
References: <20130211190317.GA19768@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:39622 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933936Ab3BMMGP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 07:06:15 -0500
In-Reply-To: <20130211190317.GA19768@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Monday 11 February 2013 22:03:18 Dan Carpenter wrote:
> This bug was introduced back in bitkeeper days in 2003.  We use
> "dcb->dev_mode" before it has been initialized.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
