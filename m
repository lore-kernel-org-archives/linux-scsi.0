From: "Kai OM" <epimetreus@fastmail.fm>
Subject: Re: Sym53c8xx_2
Date: Tue, 17 Aug 2004 06:24:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092738272.28646.202482540@webmail.messagingengine.com>
References: <1092366037.28144.202254467@webmail.messagingengine.com>
   <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
   <1092432298.18813.202307545@webmail.messagingengine.com>
   <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
   <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
   <1092624889.15338.202386294@webmail.messagingengine.com>
   <41209D02.6010202@jound.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frontend1.messagingengine.com ([66.111.4.30]:24532 "EHLO
	frontend1.messagingengine.com") by vger.kernel.org with ESMTP
	id S264750AbUHQKYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 06:24:32 -0400
Content-Disposition: inline
In-Reply-To: <41209D02.6010202@jound.net>
List-Id: linux-scsi@vger.kernel.org
To: Lance Dryden <lance@jound.net>, linux-scsi@vger.kernel.org


On Mon, 16 Aug 2004 07:39:46 -0400, "Lance Dryden" <lance@jound.net>
said:

> I can replicate the same problem with a Tekram DC390U3W, which is also
> based on the LSI53C1010.  I am guessing it's a specific problem with the
> 53c1010, as I have since replaced it with a 53c895-based card (Tekram
> DC390U2W) and it functions normally in the same system.
> 
> For me, the failure symptom starts with domain validation of the first 
> device on the bus (Quantum Atlas V 18).  The last lines indicate that 
> domain validation is beginning for the device.  After a delay, the SCSI 
> layer reports an attempted device reset.  Once that finishes, another 
> delay and then the SCSI layer reports an attempted bus reset.  I will 
> need to re-attach a c1010 to the host in order to provide a precise log.

The device I have attached to my LSIU160 is a Quantum Atlas 10K II.
Model ATLAS10K2-TY734J.
I wonder if it's an issue with 53c1010 variants in general, or maybe
only when connected to certain devices?

Can you test a different drive on the 53c1010 controller?
