From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH 7/11] drivers/scsi: Eliminate a NULL pointer dereference
Date: Thu, 27 May 2010 19:08:16 +0200
Message-ID: <4BFEA700.20603@bfs.de>
References: <Pine.LNX.4.64.1005271433330.5422@ask.diku.dk> <20100527165301.GU22515@bicker>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:51689 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208Ab0E0RIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2010 13:08:21 -0400
In-Reply-To: <20100527165301.GU22515@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, Julia Lawall <julia@diku.dk>, HighPoint Linux Team <linux@highpoint-tech.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.ker



Dan Carpenter schrieb:
> On Thu, May 27, 2010 at 02:33:47PM +0200, Julia Lawall wrote:
>> If it is a problem to use 0 when host is NULL, then the code could be fixed
>> in another way.
>>
> 
> Yeah.  It seems like it would be better to give a clearly bogus number.
> I would have said -1 but "scsi-1" looks normal so maybe something like 
> 9999999?
> 

lets spend some bytes:

	
	if (host)
		dprintk("scsi%d: hptiop_probe failed\n",host->host_no);
	else
		dprintk("scsi: no host, hptiop_probe failed\n");



re,
 wh

