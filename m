From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH update] SCSI: update Kconfig help text to indicate SCSI
 core's widespread usage
Date: Sat, 15 Sep 2007 19:52:38 +0900
Message-ID: <20070914114042M.tomof@acm.org>
References: <tkrat.0e73b94c1e80a481@s5r6.in-berlin.de>
	<20070914031256T.tomof@acm.org>
	<46EB78A3.9050404@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:44167 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbXIOKxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Sep 2007 06:53:31 -0400
In-Reply-To: <46EB78A3.9050404@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: tomof@acm.org, lsorense@csclub.uwaterloo.ca, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, jeff@garzik.org, andi@firstfloor.org, folkert@vanheusden.com, bunk@kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sat, 15 Sep 2007 08:16:03 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> FUJITA Tomonori wrote:
> > On Fri, 14 Sep 2007 23:14:21 +0200 (CEST)
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> ...
> >> And one more update:
> >> There is SAS too,
> ...
> >> +	  You need it
> >> +	  - for classic parallel SCSI hardware,
> >> +	  - for newer SCSI transports such as Fibre Channel, FireWire storage,
> >> +	    SAS, or iSCSI,
> > 
> > There is SRP too.
> 
> I think I'll rewrite it as "for newer SCSI transports such as FireWire
> storage."  ;-)
> 
> If SRP was in, can 'such as' be omitted?  "for newer SCSI transports
> (Fibre Channel, FireWire storage, iSCSI, SAS, SRP),"

It might be necessary to add SSA too.


> Or would be "for newer SCSI transports such as Fibre Channel,
> FireWire storage, iSCSI, SAS, and more," be OK?

scsi-ml has SPI, FC, iSCSI, SAS, and SRP transport classes (SRP is in
scsi-misc now). It's a bit strange to omit only SRP, I think. But I
might be too SRP-biased.
