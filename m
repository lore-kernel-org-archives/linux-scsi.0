From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 22:53:25 -0600 (CST)
Message-ID: <20071208045325.7C8F1DBA2@gherkin.frus.com>
References: <1197062383.5483.46.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:40798 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXLHExk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 23:53:40 -0500
In-Reply-To: <1197062383.5483.46.camel@lov.site> "from Kay Sievers at Dec 7,
 2007 10:19:43 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Cree <mcree@orcon.net.nz>, Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com

Kay Sievers wrote:
> Is the udev daemon (still) running while it fails?

Yes.

> If you run /sbin/udevtrigger, do the nodes appear?

No.  Exit status is 0, and there are no errors.  Everything looks
fine under /sys/block, and there doesn't seem to be a problem with
/proc/devices either.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
