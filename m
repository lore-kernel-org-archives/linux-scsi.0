From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH/RFT] libata "DMA timeout" fix
Date: 28 Feb 2004 15:28:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078003712.2020.92.camel@mulgrave>
References: <4040E7B5.4020709@pobox.com>
	<1078001357.2020.90.camel@mulgrave>  <404106D7.8050809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:33766 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261924AbUB1V2f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 16:28:35 -0500
In-Reply-To: <404106D7.8050809@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-02-28 at 15:23, Jeff Garzik wrote:
> Yeah, that's much better.  That function is not exported though ;-)

I can fix that.  It really is a necessary function for drivers doing
their own strategy handler ... of which yours seems to be the only one.

James


