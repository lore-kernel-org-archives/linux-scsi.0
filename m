From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: new kernel = megaraid performance cut in half
Date: Thu, 16 May 2002 10:50:59 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0205161049170.1330-100000@uplift.swm.pp.se>
References: <3CE0D0F4.3000601@aptalaska.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost (swmike@localhost)
	by uplift.swm.pp.se (8.11.6/8.9.3) with ESMTP id g4G8oxr12643
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2002 10:50:59 +0200
In-Reply-To: <3CE0D0F4.3000601@aptalaska.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, 14 May 2002, Matthew Schumacher wrote:

> Is there anything I can do to resolve the speed issue so that I can 
> continue using the 2.4.18 kernel?  This box is serving mail so 21MB sec 
> on 3x10000rpm scsi3 disks in a raid 5 array is not acceptable.

I am running 7.3 (upgraded from 7.2) and I feel that the 2.4.18 kernel
with the new VM code is actually inferior to that of 2.4.9-31. I have lots
of memory (1.2 gig) and lots of disk access, and I see more swap and worse
interactive performance on 2.4.18 (redhat supplied kernel) as compared to 
the redhat supplied 2.4.9-31 for 7.2.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

