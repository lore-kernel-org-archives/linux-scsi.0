From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 17:50:52 +0100
Message-ID: <e2e108260801300850o199f336fiaa55b80bfb7d5d12@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <1201710871.3292.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:17800 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYA3Quz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 11:50:55 -0500
Received: by el-out-1112.google.com with SMTP id v27so78106ele.23
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 08:50:53 -0800 (PST)
In-Reply-To: <1201710871.3292.22.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Jan 30, 2008 5:34 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2008-01-30 at 09:38 +0100, Bart Van Assche wrote:
> > On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > >
> > > iSER has parameters to limit the maximum size of RDMA (it needs to
> > > repeat RDMA with a poor configuration)?
> >
> > Please specify which parameters you are referring to. As you know I
> > had already repeated my tests with ridiculously high values for the
> > following iSER parameters: FirstBurstLength, MaxBurstLength and
> > MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
> > size specified to dd).
>
> the 1Mb block size is a bit of a red herring.  Unless you've
> specifically increased the max_sector_size and are using an sg_chain
> converted driver, on x86 the maximum possible transfer accumulation is
> 0.5MB.

I did not publish the results, but I have also done tests with other
block sizes. The other sizes I tested were between 0.1MB and 10MB. The
performance difference for these other sizes compared to a block size
of 1MB was small (smaller than the variance between individual tests
results).

Bart.
