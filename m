From: Dag Nygren <dag@newtech.fi>
Subject: Re: Bug in the sg driver
Date: Tue, 07 Oct 2003 08:47:00 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007054700.4302.qmail@dag.newtech.fi>
References: <rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip213-185-39-113.laajakaista.mtv3.fi ([213.185.39.113]:25729
	"HELO dag.newtech.fi") by vger.kernel.org with SMTP id S261799AbTJGFrC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 01:47:02 -0400
In-Reply-To: Message from "Randy.Dunlap" <rddunlap@osdl.org>
   of "Mon, 06 Oct 2003 15:18:12 PDT." <20031006151812.57a641d1.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Dag Nygren <dag@newtech.fi>, linux-scsi@vger.kernel.orgdag@newtech.fi

> On Mon, 06 Oct 2003 22:11:35 +0300 Dag Nygren <dag@newtech.fi> wrote:
> 
> 
> Is your oops/panic like this one?

Yep, at least from sg_ioctl down.

> mptscsih_qcmd is in the Fusion MPT driver.
> Looks like it is having problems with a scatter-gather list
> (actually with PCI mapping of it).
> I can't tell if the Fusion driver begins the problem or if
> sg begins it and passes it along.

Our driver is the aic7xxx, the board is an Adaptec 19160.

> Can you try a current 2.4.22 kernel?  This driver has been updated
> some since 2.4.20.  I don't know that this bug is fixed, however.

Not until Redhat compiles one, as we don't want to use anything
not Redhat for this installation.

> If you get this bug again, please run the logged text thru ksymoops
> so that it is more usable.

Yes, and we will also try to capture "our" oops this time.
Coming to think about it, it is probably logged somewhere...
Not the successive Panic, but the oops should be there. I will investigate
a bit..

> What makes the kernel "Tainted"?

Our kernel is a stock Redhat 9.0 kernel and shouldn't be tainted.

-- Dag

