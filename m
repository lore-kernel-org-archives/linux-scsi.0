From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [patch 2/7] scsi/ppa: replace schedule_timeout() with msleep()
Date: Wed, 12 Jan 2005 15:40:43 -0800
Message-ID: <20050112234043.GA2688@us.ibm.com>
References: <20050111232251.3BBB31F226@trashy.coderock.org> <1105547090.5577.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:65186 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261583AbVALXk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 18:40:57 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0CNepBW009601
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 18:40:51 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0CNejHZ288400
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 18:40:45 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0CNejXh013953
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 18:40:45 -0500
Content-Disposition: inline
In-Reply-To: <1105547090.5577.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: domen@coderock.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, janitor@sternwelten.at

On Wed, Jan 12, 2005 at 10:24:50AM -0600, James Bottomley wrote:
> On Wed, 2005-01-12 at 00:22 +0100, domen@coderock.org wrote:
> > -		schedule_timeout(3 * HZ);
> > +		msleep(3000);
> 
> This would make more sense as ssleep(3), wouldn't it?

Actually, this patch should be dropped! :) msleep() will ignore any wait-queue
events (triggered because of the prepare_to_wait() call). So please revert, if
applied.

Thanks,
Nish
