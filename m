From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 0/1] qla2xxx: fix for 2.6.33-rcX
Date: Fri, 12 Feb 2010 12:26:40 -0800
Message-ID: <20100212202640.GA21801@kroah.com>
References: <1265168913-353-1-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:50025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab0BLUef (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2010 15:34:35 -0500
Content-Disposition: inline
In-Reply-To: <1265168913-353-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: James.Bottomley@HansenPartnership.com, stable@kernel.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Tue, Feb 02, 2010 at 07:48:32PM -0800, giridhar.malavali@qlogic.com wrote:
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> 
> James,
> 
> Can you please apply this patch. This is a critical fix which can cause
> panic issues (found on PPC). This needs to be back ported to stable kernel.

This patch is now in Linus's tree, yet it does not apply to the
2.6.32-stable kernel.  Can you please send a version that does to the
stable@kernel.org address so that I can apply it?

thanks,

greg k-h
