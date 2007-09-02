From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm] DC395x SCSI driver: Shut up uninitialized variable
 build warning
Date: Sun, 02 Sep 2007 16:43:28 -0400
Message-ID: <46DB2070.9010608@garzik.org>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in> <46DB1BDF.4090100@garzik.org> <alpine.LFD.0.999.0709030211040.29617@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52344 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXIBUna (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Sep 2007 16:43:30 -0400
In-Reply-To: <alpine.LFD.0.999.0709030211040.29617@enigma.security.iitk.ac.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.name>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>

Satyam Sharma wrote:
> I'll post the info as a reply to the first mail in this series. I have
> fairly recent gcc (4.1.1) and I don't see us dropping support for it in
> the next few years.

What's important is not support lifetime, but whether or not the warning 
persists through version 4.1.2, 4.1.3, etc.

We don't want to add markers for compiler quirks that come and go.

The current markers tend to exist for a class of problems that gcc 
fundamentally has a tough time "seeing."  Different optimizer behaviors 
from compiler version to compiler version are just noise[1].

	Jeff


[1] sometimes quite literally, in the case of compiler warnings.

