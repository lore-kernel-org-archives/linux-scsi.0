From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: disable split completion timer/setting by default
Date: Fri, 30 Jun 2006 17:17:09 -0400
Message-ID: <44A594D5.4040906@garzik.org>
References: <1151701856.16075.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:42436 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932609AbWF3VRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 17:17:12 -0400
In-Reply-To: <1151701856.16075.59.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Alexis Bruemmer wrote:
> The aic94xx driver will lock up under heavy load with a split completion
> error.  There is a split completion timer/setting which should be
> disabled by default but is not.  This patch fixes this problem.
> 
> Signed-off-by: Adaptec
> Acked-by: Alexis Bruemmer <alexisb@us.ibm.com>

There are various aic94xx driver bits floating about, and I'm worried 
that it will stay forever outside the kernel.org tree.

Can you (a) make sure to CC linux-scsi@vger.kernel.org on all aic94xx 
patches, and (b) work with James Bottomley and the crew to get it 
working with the upstream tree?

	Jeff



