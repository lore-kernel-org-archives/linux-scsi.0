From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Thu, 31 Jul 2008 15:19:48 -0600
Message-ID: <1217539188.14886.10.camel@bluto.andrew>
References: <20080619160342.GJ4392@parisc-linux.org>
	 <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com>
	 <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
	 <20080625172015.GR4392@parisc-linux.org> <20080625172638.GE20851@kernel.dk>
	 <yq1d4m575je.fsf@sermon.lab.mkp.net> <488DCB5A.9080105@redhat.com>
	 <yq1od4ikrl2.fsf@sermon.lab.mkp.net>
	 <da824cf30807311400i59065c74q549aa1b62819781e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8020 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYGaVTu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 17:19:50 -0400
In-Reply-To: <da824cf30807311400i59065c74q549aa1b62819781e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Thu, 2008-07-31 at 14:00 -0700, Grant Grundler wrote:
> On Mon, Jul 28, 2008 at 7:31 AM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >>>>>> "Ric" == Ric Wheeler <rwheeler@redhat.com> writes:
> >
> > Ric> One other thought - is there a way to give non-rotational devices
> > Ric> also some indication of latency? (FLASH is slower than enterprise
> > Ric> SSD is slower than DRAM ramdisk for example)?
> >
> > The current SBC draft only distinguishes between rotating media
> > speeds.  There is only one classification for non-rotating media in
> > the block device characteristics VPD.
> >
> > For a mechanical disk drive the rpm isn't a terrible gauge for
> > performance.  But for a solid state device I think it will be hard to
> > define a similar universal metric.
> 
> rpm isn't a great gauge of performance either since the perf is a
> function of rpm * bit density.
> 
> > Ignoring SLC vs. MLC for a moment I think it's also safe to predict
> > that the enterprise drive of today will be the consumer drive of
> > tomorrow.
> >
> > Maybe the ssd device could export the anticipated command response
> > time for a request that matches the Optimal Transfer Length field in
> > the block limits VPD?
> 
> erase and/or write times could be exported as well somehow for SSDs
> if the FS (or other higher layer that wants to know) can't avoid
> garbage collection and erase cycles. I was just told today that flash devices
> have 10x higher write time than read time. erase is another order of
> magnitude higher. This doesn't include any garbage collection overhead.
> 
> I think new file systems should be tuned to work with SSDs before we
> worry so much about the differences between SSDs/flash technologies
> and vendors. And then prescribe a different FS for different
> storage technologies. This avoids the "layering violations" discussion
> and helps keep the FSs (testing and developement) substantially simpler.
> 

Could performance patterns be encoded in some sort of per-product data
structure ala the scsi_static_device_list?

Andrwe

