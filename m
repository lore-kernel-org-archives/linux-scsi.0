From: "Paul Blazejowski" <paulb@blazebox.homeip.net>
Subject: Re: Badness in device_release at drivers/base/core.c:84
Date: Mon, 4 Aug 2003 22:21:31 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <5793.199.181.174.146.1060050091.squirrel@www.blazebox.homeip.net>
References: <20030801182207.GA3759@blazebox.homeip.net>	
    <20030801144455.450d8e52.akpm@osdl.org>	
    <20030803015510.GB4696@blazebox.homeip.net>	
    <20030802190737.3c41d4d8.akpm@osdl.org>	
    <20030803214755.GA1010@blazebox.homeip.net>	
    <20030803145211.29eb5e7c.akpm@osdl.org>	
    <20030803222313.GA1090@blazebox.homeip.net>	
    <20030803223115.GA1132@blazebox.homeip.net>	
    <20030804093035.A24860@beaverton.ibm.com>
    <1060021614.889.6.camel@blaze.homeip.net>
    <1352160000.1060025773@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1352160000.1060025773@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Patrick Mansfield  <patmans@us.ibm.com>, Andrew Morton  <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>
> You might be able to get useful information without using a serial
> console if you turn off your CDROM drives so they don't add extra output,
> but your best bet is to use a serial console.
>
> --
> Justin
>
>
>

Justin,

I am going to try with the SCSI disk drive alone after diconnecting the
cdrom drivers.

I'll look into serial console and try to set it up.Do i need extra
hardware or cables to run serial console? any poniters or setup
suggestions would be welcome as i never used serial consoles before.
Regards,

Paul
