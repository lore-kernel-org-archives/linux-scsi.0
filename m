From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic7xxx: fix compiler warning from dma mask assignement
Date: 18 Nov 2004 14:28:04 -0600
Message-ID: <1100809690.1574.8.camel@mulgrave>
References: <20041118122415.539351f9@zqx3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21919 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261163AbUKRU2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 15:28:18 -0500
In-Reply-To: <20041118122415.539351f9@zqx3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <shemminger@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-11-18 at 14:24, Stephen Hemminger wrote:
> Get rid of a compiler warning because assignment truncating a 64 bit constant
> and use existing definitions.
> 
> Signed-off-by: Stephen Hemminger <shemminger@osdl.org>

Actually, I floated a slightly more comprehensive version of the patch
here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=110064141503088

Could you check that this works for you?

Thanks,

James


