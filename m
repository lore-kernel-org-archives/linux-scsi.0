From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 04 Mar 2009 00:32:57 +0100
Message-ID: <49ADBE29.4040706@s5r6.in-berlin.de>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr> <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain> <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20090303230323.GA21644@elte.hu>
Sender: linux-rt-users-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Ingo Molnar wrote:
> i picked up a v1 patch from the SCSI list that 
> i reported and which patch was sent to me. I did that in the 
> hope to fix a serious lockup bug that is still unfixed in the
> upstream kernel

Perhaps you could avoid putting such fixes into published merge
branches.  Have it in an off-topic branch and tell people with affected
systems to locally merge such a branch themselves if it is strictly
necessary to keep their development rolling.  (And if such an off-topic
branch turns out to be unexpectedly long-lived, ping the choke point.)
Just so that there is minimal surprise about which modifications your
trees carry.
-- 
Stefan Richter
-=====-==--= --== --=--
http://arcgraph.de/sr/
