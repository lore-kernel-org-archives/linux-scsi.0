From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.9 aacraid: Support ROMB RAID/SCSI mode - Resend -
Date: Thu, 18 Nov 2004 19:34:28 +0000
Message-ID: <20041118193428.GA26622@infradead.org>
References: <1100800586.6026.31.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:64775 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262920AbUKRTec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 14:34:32 -0500
Content-Disposition: inline
In-Reply-To: <1100800586.6026.31.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> +	if ((dev->adapter_info.options & AAC_OPT_SCSI_MANAGED)
> +		&& (dev->adapter_info.options & AAC_OPT_RAID_SCSI_MODE)) {

Should be

	if ((dev->adapter_info.options & AAC_OPT_SCSI_MANAGED) &&
	    (dev->adapter_info.options & AAC_OPT_RAID_SCSI_MODE)) {

