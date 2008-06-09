From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Reallocating sd device
Date: Tue, 10 Jun 2008 08:17:21 +1200
Message-ID: <484D8FD1.60000@sauce.co.nz>
References: <484D8935.70905@sauce.co.nz> <1213041283.3508.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sauce.co.nz ([210.48.49.72]:35364 "EHLO smtp.sauce.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbYFIUI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2008 16:08:26 -0400
In-Reply-To: <1213041283.3508.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:

> Not really ... relying on a specific sdX name has been deprecated for a
> while.  To ensure absolute ordering, you should be using the device by
> id or by label.
> 
> James

Thanks. I was trying to avoid the extra work of modifying smartd.conf 
files after drives are replaced, which seem to only be able to use 
/dev/sdX, or am I missing something?

Regards,

Richard

