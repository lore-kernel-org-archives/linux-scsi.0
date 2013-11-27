From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Re: scsi-mq + open-iscsi support patches..?
Date: Wed, 27 Nov 2013 10:43:40 -0800
Message-ID: <1385577820.4307.144.camel@haakon3.risingtidesystems.com>
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
	 <5273BEBF.2090008@cs.wisc.edu>
	 <1383338230.4216.9.camel@haakon3.risingtidesystems.com>
	 <37724B2049F71D4C9B086F99DDB2DE1126E31C7C@CMEXMB1.ad.emulex.com>
	 ,  <1383591411.4216.25.camel@haakon3.risingtidesystems.com>
	 <201311271046199969490@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <201311271046199969490@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Jianpeng,

(Trimming CC's)

On Wed, 2013-11-27 at 10:46 +0800, kedacomkernel wrote:
> Hi all=EF=BC=8C
> 	I used target-pending/scsi-mq to test intel ahci=EF=BC=8Cbut it can'=
t work.I
> modify some places, now it can work.But still met hung task or oops.

So after looking at your patches sent offlist, I don't exactly
understand why they are necessary for AHCI to function.

> Who can receive my patch for that?

Please repost your patches to linux-scsi, with the specifics of each bu=
g
you've encountered, and why each patch is necessary to address the
issue.

Thanks!

--nab
