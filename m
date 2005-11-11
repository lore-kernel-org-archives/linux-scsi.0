From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 3/3] HCIL accraid updates
Date: Fri, 11 Nov 2005 06:55:00 -0500
Message-ID: <43748694.2080902@pobox.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01CBC638@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:60296 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750746AbVKKLzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 06:55:06 -0500
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01CBC638@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Salyzyn, Mark wrote:
> No problem from me.

Thanks.


> Would have preferred the patch to cut the cord completely and drop all
> the container to id macros, that can follow in a cosmetic cleanup patch
> behind all the big ones on their way.

Yeah, I did that locally, but couldn't add it to the patch you saw due 
to unrelated struct scsi_lun changes I've been working on.

	Jeff


