From: Lance Dryden <lance@jound.net>
Subject: sym53c8xx_2 version 2.1.18j domain validation failures (was Re: Sym53c8xx_2)
Date: Sat, 21 Aug 2004 18:51:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4127D208.6010600@jound.net>
References: <1092366037.28144.202254467@webmail.messagingengine.com>   <Pine.LNX.4.60.0408132049060.4069@poirot.grange>   <1092432298.18813.202307545@webmail.messagingengine.com>   <Pine.LNX.4.60.0408150005570.5333@poirot.grange>   <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>   <1092624889.15338.202386294@webmail.messagingengine.com>   <41209D02.6010202@jound.net> <1092738272.28646.202482540@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-200-116.nyc2.dsl.speakeasy.net ([64.81.200.116]:3715
	"EHLO ellision") by vger.kernel.org with ESMTP id S267993AbUHUWwJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 18:52:09 -0400
In-Reply-To: <1092738272.28646.202482540@webmail.messagingengine.com>
List-Id: linux-scsi@vger.kernel.org
To: Kai OM <epimetreus@fastmail.fm>
Cc: linux-scsi@vger.kernel.org

Apologies for the late reply.

What I have found is that only my Quantum Atlas disks seem to have the 
problem with domain validation at boot-up.

My results are below.  The first test was successful, the second was 
not.  Both host adapters were installed and enumerated by the kernel in 
the order listed.  Kernel was 2.6.8.1 from kernel.org.

=== BEGIN TEST 1 ===
53c895
- 2x Quantum Atlas V
- 1x Ecrix VXA-1
53c1010
- 1x Compaq OEM device
- 1x Plextor
Status: Successful DV, all devices

=== BEGIN TEST 2 ===
53c895
- 1x Atlas
- 1x Ecrix
53c1010
- 1x Atlas
- 1x Compaq
- 1x Plextor
Status: UNSUCCESSFUL DV against
- Vendor:"QUANTUM" Model:"ATLAS_V_18_WLS" Rev:"0200"

=== BEGIN TEST 2 CONSOLE LOG SNIPPET ===
sym1:2:0: tagged command queueing enabled, command queue depth 16
scsi(1:0:2:0): Beginning Domain Validation
sym1:2: wide asynchronous
sym1:2:0: ABORT operation started.
sym1:2:0: ABORT operation timed-out
sym1:2:0: DEVICE RESET operation started
sym1:2:0: DEVICE RESET operation timed-out.
sym1:2:0: BUS RESET operation started.
sym1: SCSI BUS reset detected.
sym1: SCSI BUS has been reset.
sym1:2:0: BUS RESET operation complete
sym1:2:0: ABORT operation started.
sym1:2:0: ABORT operation timed-out.
sym1:2:0: HOST RESET operation started.
sym1: SCSI BUS has been reset
=== END TEST 2 CONSOLE LOG SNIPPET ===

I wonder if anyone around can test with some more Quantum Atlas drives 
against a 53c1010.

   Cheers,
   Lance Dryden

Kai OM wrote:
> 
> The device I have attached to my LSIU160 is a Quantum Atlas 10K II.
> Model ATLAS10K2-TY734J.
> I wonder if it's an issue with 53c1010 variants in general, or maybe
> only when connected to certain devices?
> 
> Can you test a different drive on the 53c1010 controller?
