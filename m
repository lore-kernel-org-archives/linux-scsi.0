From: Willem Riede <wrlk@riede.org>
Subject: Re: ide-scsi with ide-hd?
Date: Fri, 6 Dec 2002 08:45:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021206134519.GF3664@linnie.riede.org>
References: <3DF06AD0.5070507@rzg.mpg.de> <3DF07BDF.8070907@torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gB6DjJC01771
	for <linux-scsi@vger.kernel.org>; Fri, 6 Dec 2002 08:45:19 -0500
Content-Disposition: inline
In-Reply-To: <3DF07BDF.8070907@torque.net>; from dougg@torque.net on Fri, Dec 06, 2002 at 05:28:47 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2002.12.06 05:28 Douglas Gilbert wrote:
> 
> The ide-scsi driver looks like it is going away in the
> 2.5 series **.  
> 
> ** Are there ATAPI tape drives using the ide-scsi driver?
> 
Yes there are. Osst supports the IDE/ATAPI variant of the OnStream
tape drives (DI-30 and DI-50). I have been wondering about what to
do given that I had read before that ide-scsi is on its way out
but have not seen any discussion that covers what to do instead in
all cases. If someone can give me instructions on how to bypass
ide-scsi when driving the DI-30 from my osst tape driver, I'll be
happy to work on that.

I am pretty sure there are also generic ATAPI tape drives, (I have
one I use for comparison) but ide-tape may be what we want to be 
used to drive them (though it is not in great shape either).
If we want to get rid of ide-tape too, Kai Makisara (st.c) would 
have a use for the same ide-scsi-replacement as I'm going to need.

Thanks, Willem Riede.
