From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Mon, 27 Oct 2008 13:54:42 +0900
Message-ID: <20081027135322Y.fujita.tomonori@lab.ntt.co.jp>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
	<0F5B06BAB751E047AB5C87D1F77A77884C01B0C584@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752704AbYJ0EzP@vger.kernel.org>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77884C01B0C584@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike.Miller@hp.com
Cc: fujita.tomonori@lab.ntt.co.jp, Tom.Lawler@hp.com, James.Bottomley@HansenPartnership.com, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 24 Oct 2008 15:10:57 +0000
"Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:

> Tomo wrote:
> 
> >
> > My scsi driver is still in an early stage (I tried to keep
> > the changes minimum). I can detect logical units, mount a
> > file system, do lots of I/Os, however, there are lots of
> > TODOs in the management features.
> >
> > If I can get an ACK from HP about the long-term migration of
> > cciss to SCSI, I'm happy to keep working on the SCSI cciss
> > driver and maintain it until HP takes over the driver.
> 
> Just a brief update. HP has developed a scsi version of cciss. It was originally done for another environment but we have decided to use it as the base for Linux. It was authored by Tom Lawler of HP. We are currently in the process of getting the Open Source Review Board approval to release the code to the community.
> 
> It's unclear right now as to who will be the maintainer.

Awesome, I'm really looking forward to the release.

Thanks!
