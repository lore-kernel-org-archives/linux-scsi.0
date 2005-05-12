From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Re[2]: ata over ethernet question
Date: Thu, 12 May 2005 15:15:12 -0400
Message-ID: <1115925312.5042.24.camel@mulgrave>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
	 <1115236116.7761.19.camel@dhollis-lnx.sunera.com>
	 <1104082357.20050504231722@dns.toxicfilms.tv>
	 <1115305794.3071.5.camel@dhollis-lnx.sunera.com>
	 <20050507150538.GA800@favonius>
	 <Pine.LNX.4.60.0505102352430.9008@poirot.grange>
	 <1115923927.5042.18.camel@mulgrave>  <1115924747.25161.150.camel@beastie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41433 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261417AbVELTPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 May 2005 15:15:30 -0400
In-Reply-To: <1115924747.25161.150.camel@beastie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Yusupov <dmitry_yus@yahoo.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Sander <sander@humilis.net>, David Hollis <dhollis@davehollis.com>, Maciej Soltysiak <solt2@dns.toxicfilms.tv>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-05-12 at 12:05 -0700, Dmitry Yusupov wrote:
> oh, please! don't compare nbd and iSCSI this way...
> iSCSI is an emerging SAN technology, and the only technology to compare
> is FC.

Well, the question was whether iSCSI could replace nbd; It's rather
difficult to answer that question by comparing iSCSI to FC ...

But even projecting to iSCSI being totally mature, the amount of code
required to conform to the iSCSI standard is easily going to put it 10x
over the amount of code we have in nbd, principally because they're
aimed at solving different problems and nbd achieves a lot of
streamlining by being tied to the linux block subsystem instead of
trying to be a generic transport.

James


