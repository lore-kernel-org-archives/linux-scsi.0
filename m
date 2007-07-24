From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and auditing
Date: Tue, 24 Jul 2007 13:12:19 +0300
Message-ID: <46A5D083.50803@panasas.com>
References: <4695F76F.5000305@panasas.com>	<20070712135750.2a4a4a54.rdunlap@xenotime.net>	<469B38CC.50501@panasas.com>	<20070717171607.ffc278eb.rdunlap@xenotime.net>	<469DDD74.2060208@panasas.com>	<20070718103320.4b6ad7b3.rdunlap@xenotime.net>	<20070718145818.8eebbd66.rdunlap@xenotime.net>	<20070718194335.e21a01e5.rdunlap@xenotime.net>	<20070718200315.3adcd194.rdunlap@xenotime.net>	<469F616D.1000909@panasas.com>	<20070719083719.33d8994c.rdunlap@xenotime.net>	<469F89FE.4080900@panasas.com> <20070719104930.7ae87df8.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16041 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762386AbXGXKMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 06:12:36 -0400
In-Reply-To: <20070719104930.7ae87df8.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, scsi <linux-scsi@vger.kernel.org>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_F?= =?ISO-8859-1?Q?ischer=22?= <fischer@norbit.de>

Randy Dunlap wrote:
> I prefer either of the !HIGHMEM or slave_alloc changes to adding
> a BUG_ON().  However, the SCSI people likely won't want to use the
> slave_alloc() change because then the driver may never get fixed.
> (Of course, it hasn't got fixed with the BUG happening either.)
> 
> Anyway, I'll re-read Documentation/DMA*.txt to see if I can fix it.
> 
> ---

Hi Randy.

could you please send me the patch you have with the .slave_alloc
solution for now. I would like to revise the patchset and send them
for inclusion now. They do fix some problems and let users work.
We can put a big fat warring and explanation about highmem in the
commit log comments so people can watch out.

Thanks
Boaz
