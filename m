From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 18:53:20 +0100
Message-ID: <AANLkTinSpmjL+eK+UHSViETJn8uqcSE63Zi8XUKnmfPi@mail.gmail.com>
References: <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <20101115065919.GB14442@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64945 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab0KORxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 12:53:43 -0500
In-Reply-To: <20101115065919.GB14442@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Mon, Nov 15, 2010 at 7:59 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> [ ... ]
> This is quite unfortunate as I still have not seen the public comparison
> of the 2 implementations and the lists of benefits and shortfalls for
> both of them.

The reason why we are proposing SCST for upstream inclusion are:
- It has a large user base.
- The project is known for its high performance, low latency I/O and
excellent stability.
- A feature-wise overview can be found here:
http://scst.sourceforge.net/comparison.html.

Bart.
