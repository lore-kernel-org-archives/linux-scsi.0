From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [ANNOUNCE] QLogic FC Driver for Linux kernel 2.5 available.
Date: 12 May 2003 17:03:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052777037.3629.15.camel@mulgrave>
References: <3EC017E1.3050507@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:12037 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262294AbTELVvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 17:51:19 -0400
In-Reply-To: <3EC017E1.3050507@wanadoo.es>
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jes@wildopensource.com

On Mon, 2003-05-12 at 16:53, Xose Vazquez Perez wrote:
> you have here latest drivers/firmware:

Does that mean "no"?

>  - latest: 3.12 August 17, 2000 http://download.qlogic.com/drivers/2206/qla1x160src-3.12.tgz
>  - beta: 3.23  January 12, 2001 http://download.qlogic.com/drivers/2209/qla1x160src-3.23Beta.tgz

There is little chance that a 2001 driver will compile in 2.5, let alone
run.  Also, I can't find a driver for the ISP1020/1040---unless it's
hiding somewhere.

James


