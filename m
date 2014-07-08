From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH 3/3] scsi: ufs: retry if the link-startup fails
Date: Tue, 8 Jul 2014 03:35:04 -0700
Message-ID: <20140708103504.GA18875@infradead.org>
References: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
 <1404206559-21445-4-git-send-email-draviv@codeaurora.org>
 <20140707103719.GA7810@infradead.org>
 <00d701cf9a95$f7f3ac20$e7db0460$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaGHKfG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 06:35:06 -0400
Content-Disposition: inline
In-Reply-To: <00d701cf9a95$f7f3ac20$e7db0460$@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com

On Tue, Jul 08, 2014 at 01:18:27PM +0300, Dolev Raviv wrote:
> > Did you plan to change the arguments to ufshcd_is_device_present in a later patch?
> I guess I overlooked it, thanks for bringing it to my attention.
> I will resend the series without this patch.

If the series works just fine without this patch I'm happy to drop it
locally, no need to resend.

