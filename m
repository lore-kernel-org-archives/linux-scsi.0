From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Badness in device_release at drivers/base/core.c:84
Date: Mon, 04 Aug 2003 13:36:13 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1352160000.1060025773@aslan.btc.adaptec.com>
References: <20030801182207.GA3759@blazebox.homeip.net>	 <20030801144455.450d8e52.akpm@osdl.org>	 <20030803015510.GB4696@blazebox.homeip.net>	 <20030802190737.3c41d4d8.akpm@osdl.org>	 <20030803214755.GA1010@blazebox.homeip.net>	 <20030803145211.29eb5e7c.akpm@osdl.org>	 <20030803222313.GA1090@blazebox.homeip.net>	 <20030803223115.GA1132@blazebox.homeip.net>	 <20030804093035.A24860@beaverton.ibm.com> <1060021614.889.6.camel@blaze.homeip.net>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1060021614.889.6.camel@blaze.homeip.net>
Content-Disposition: inline
To: Paul Blazejowski <paulb@blazebox.homeip.net>, Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Patrick,
> 
> I enabled CONFIG_SCSI_LOGGING=y in kernel then i used
> scsi_mod.scsi_logging_level=0x140 and scsi_mod.max_scsi_luns=1 when
> booting the kernel from lilo.I can see some debug information scroll on
> the screen and i did see ID0 LUN0 get probed even the correct transfer
> rate for the SCSI disk is set.I forgot but isn't there a key sequence
> when pressed it will stop the screen output like pause/break key?

You might be able to get useful information without using a serial
console if you turn off your CDROM drives so they don't add extra output,
but your best bet is to use a serial console.

--
Justin
