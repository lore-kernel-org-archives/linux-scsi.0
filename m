From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [patch] xen-scsifront: use GFP_ATOMIC under spin_lock
Date: Mon, 8 Sep 2014 18:34:39 +0100
Message-ID: <540DE8AF.60906@citrix.com>
References: <20140908111542.GA6947@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:19625 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaIHRey (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 13:34:54 -0400
In-Reply-To: <20140908111542.GA6947@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Juergen Gross <jgross@suse.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>

On 08/09/14 12:15, Dan Carpenter wrote:
> This function is only called with a spin_lock held and IRQs disabled.
> The allocation is not allowed to sleep and NOIO is not sufficient, it
> has to be ATOMIC.

Applied this and the scsiback one to devel/for-linus-3.18.

Thanks.

David
