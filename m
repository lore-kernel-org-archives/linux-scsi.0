From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH update] SCSI: update Kconfig help text to indicate SCSI
 core's widespread usage
Date: Sat, 15 Sep 2007 21:53:55 +0900
Message-ID: <20070914134236Q.tomof@acm.org>
References: <46EB78A3.9050404@s5r6.in-berlin.de>
	<20070914114042M.tomof@acm.org>
	<46EBD052.9090608@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:33634 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXIOMys (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Sep 2007 08:54:48 -0400
In-Reply-To: <46EBD052.9090608@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: tomof@acm.org, lsorense@csclub.uwaterloo.ca, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, jeff@garzik.org, andi@firstfloor.org, folkert@vanheusden.com, bunk@kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sat, 15 Sep 2007 14:30:10 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> FUJITA Tomonori wrote:
> > On Sat, 15 Sep 2007 08:16:03 +0200
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> Or would be "for newer SCSI transports such as Fibre Channel,
> >> FireWire storage, iSCSI, SAS, and more," be OK?
> > 
> > scsi-ml has SPI, FC, iSCSI, SAS, and SRP transport classes (SRP is in
> > scsi-misc now). It's a bit strange to omit only SRP, I think. But I
> > might be too SRP-biased.
> 
> "such as... and more" suggests that there are indeed more SCSI
> transports supported by Linux than mentioned in this help text.

I think that you can remove "such as" if you add SRP and SSA. "for
SCSI transports such as Fibre Channel, FireWire, SAS, iSCSI, SRP, or
SSA" should be fine. But I'm not sure that scsi-ml has a SSA hba
driver. If not, we could remove SSA.


> We could also write "such as Fibre Channel, iSCSI, SAS, and more," if
> you suspect bias on my side. ;-)  Help texts should be concise.
> -- 
> Stefan Richter
> -=====-=-=== =--= -====
> http://arcgraph.de/sr/
