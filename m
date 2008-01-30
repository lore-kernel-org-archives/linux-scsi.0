From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 09:38:04 +0100
Message-ID: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:17516 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYA3IiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 03:38:08 -0500
Received: by wx-out-0506.google.com with SMTP id h31so141880wxd.4
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 00:38:05 -0800 (PST)
In-Reply-To: <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
> iSER has parameters to limit the maximum size of RDMA (it needs to
> repeat RDMA with a poor configuration)?

Please specify which parameters you are referring to. As you know I
had already repeated my tests with ridiculously high values for the
following iSER parameters: FirstBurstLength, MaxBurstLength and
MaxRecvDataSegmentLength (16 MB, which is more than the 1 MB block
size specified to dd).

Bart Van Assche.
