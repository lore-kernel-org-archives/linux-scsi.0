From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 21 Dec 2002 08:23:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4088952704.1040484184@aslan.scsiguy.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
 <176730000.1040430221@aslan.btc.adaptec.com>
 <20021221002940.GM25000@holomorphy.com>
 <190380000.1040432350@aslan.btc.adaptec.com>
 <20021221013500.GN25000@holomorphy.com>
 <223910000.1040435985@aslan.btc.adaptec.com>
 <20021221071031.GA25566@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021221071031.GA25566@codepoet.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> Is the latest aic7xxx driver available as, say, a unified diff,
> or a tarball, or some similar usable format?

I'm generating tarballs right now.  The problem with unified diffs is
that everyone wants them against something different.  With the tarball,
and 2.4.X, you should be able to just drop in the driver on just about
any kernel version.

--
Justin

