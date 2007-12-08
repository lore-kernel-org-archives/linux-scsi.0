From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 23:05:17 -0600 (CST)
Message-ID: <20071208050517.EC35EDBA2@gherkin.frus.com>
References: <1197062383.5483.46.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755336AbXLHFFb@vger.kernel.org>
In-Reply-To: <1197062383.5483.46.camel@lov.site> "from Kay Sievers at Dec 7,
 2007 10:19:43 pm"
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Cree <mcree@orcon.net.nz>, Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com
List-Id: linux-scsi@vger.kernel.org

Kay Sievers wrote:
> Is the udev daemon (still) running while it fails?

Yes, and there's something else I forgot to mention that may be
significant...  For the bad case, in addition to udevd, "ps -ef"
shows a "sh -e /lib/udev/net.agent" running with a PPID of 1.  This
process doesn't exit until I reboot.  If this is normal under the
circumstances, please disregard.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
