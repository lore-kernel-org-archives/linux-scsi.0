From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: Re[2]: ata over ethernet question
Date: Thu, 12 May 2005 12:44:18 -0700
Message-ID: <1115927058.25161.166.camel@beastie>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
	 <1115236116.7761.19.camel@dhollis-lnx.sunera.com>
	 <1104082357.20050504231722@dns.toxicfilms.tv>
	 <1115305794.3071.5.camel@dhollis-lnx.sunera.com>
	 <20050507150538.GA800@favonius>
	 <Pine.LNX.4.60.0505102352430.9008@poirot.grange>
	 <1115923927.5042.18.camel@mulgrave>  <1115924747.25161.150.camel@beastie>
	 <1115925312.5042.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.mail.sc5.yahoo.com ([66.163.170.8]:29589 "HELO
	smtp110.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261523AbVELToU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 May 2005 15:44:20 -0400
In-Reply-To: <1115925312.5042.24.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Sander <sander@humilis.net>, David Hollis <dhollis@davehollis.com>, Maciej Soltysiak <solt2@dns.toxicfilms.tv>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-05-12 at 15:15 -0400, James Bottomley wrote:
> On Thu, 2005-05-12 at 12:05 -0700, Dmitry Yusupov wrote:
> > oh, please! don't compare nbd and iSCSI this way...
> > iSCSI is an emerging SAN technology, and the only technology to compare
> > is FC.
> 
> Well, the question was whether iSCSI could replace nbd; It's rather
> difficult to answer that question by comparing iSCSI to FC ...

ok.
i'm just reacting on "bloated" wording. It really depends on
implementation and design. If you were talking about amount of code in
the kernel, than take a look on open-iscsi(just one file iscsi_tcp.c)
and IET where we doing a lot of management stuff in user-space. It is
not that much code in the kernel, really, but it is doing x10 times more
useful things comparing to nbd and yet compliant with RFC.

> But even projecting to iSCSI being totally mature, the amount of code
> required to conform to the iSCSI standard is easily going to put it 10x
> over the amount of code we have in nbd, principally because they're
> aimed at solving different problems and nbd achieves a lot of
> streamlining by being tied to the linux block subsystem instead of
> trying to be a generic transport.

yeah, generic transport, recovery levels, direct data placement for HW
HBAs, etc, etc... it is all *must* features for enterprise's SAN
deployment. So, yes, there is a price as usual.

Dmitry.

> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

