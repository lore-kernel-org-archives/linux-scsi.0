From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: aic7xxx: SCSI Bus Reset
Date: Tue, 24 Dec 2002 12:34:16 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212241230510.3657-100000@uplift.swm.pp.se>
References: <20021224112158.GA667@exocore.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost (swmike@localhost)
	by uplift.swm.pp.se (8.11.6/8.9.3) with ESMTP id gBOBYGp28736
	for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2002 12:34:16 +0100
In-Reply-To: <20021224112158.GA667@exocore.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

On Tue, 24 Dec 2002, Shanker Balan wrote:

> Hello:
> 
> I am experience aic7xxx SCSI reset errors which happens every so often
> on my NFS server:

I get this too. Different drives from time to time, I get the same errors
either with a AH3950U2 (on a VP6 Abit motherboard) or a 7899 based U160
onboard controller (on my new Tyan 2688 motherboard). I run in LVD mode
with a cable which is less than a meter long and with a LVD-SCA 6 drive
backplane with built in termination.

My stop usually lasts for 30 seconds and then it clears and continues.

I use Redhat 7.3 as well with the redhat supplied kernels (I've tried 
different ones).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

