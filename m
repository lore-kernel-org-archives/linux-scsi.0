From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 0/8] bfa: update bfa driver to version 2.1.2.1 (resubmit)
Date: Thu, 17 Dec 2009 17:04:15 -0800
Message-ID: <04391A4E90BB2149B010D22452FA16875EF12D01@HQ-EXCH-6.corp.brocade.com>
References: <1259545058-4358-1-git-send-email-huangj@brocade.com>
	 <04391A4E90BB2149B010D22452FA16875EF12BFE@HQ-EXCH-6.corp.brocade.com>
 <1261095063.2752.34.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:10561 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZLRBET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2009 20:04:19 -0500
In-Reply-To: <1261095063.2752.34.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

> So what I can do this once is accumulate all the change logs (which were
> better than the first time around) and do a single update for 2.6.33 on
> promise of better change sets in future.
> 
> Is that OK?
> 

Thanks James, 

It sounds great if you can make this one time exception for us. For this particular case, due to the amount of the changes and the span of time, creating one patch per logic change will be a very error prone and time consuming process for us. Once this updated in included, the upstream driver will be in sync with our latest internal development, and I promise this will not happen again.

Jing

