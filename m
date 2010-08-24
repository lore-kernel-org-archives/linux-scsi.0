From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 24 Aug 2010 09:57:56 -0500
Message-ID: <1282661876.2993.20.camel@mulgrave.site>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>
	 <4C73DA15.2010207@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53868 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0HXO6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2010 10:58:03 -0400
In-Reply-To: <4C73DA15.2010207@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Tue, 2010-08-24 at 18:41 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley, on 08/22/2010 12:43 AM wrote:
> > Interface re-use (or at least ABI compatibility) is the whole point,
> > it's what makes the solution a drop in replacement.
> 
> I see now. You want ABI compatibility to keep the "contract" that no 
> kernel changes can break applications binary compatibility for unlimited 
> time.
> 
> OK, we will write the compatibility module. It shouldn't take much time.
> 
> But before we start, I'd like to clear 2 related questions:
> 
> 1. How far the ABI compatibility "contract" goes? Are there cases, where 
> it isn't so strong? I'm asking, because I can recall that open-iscsi at 
> least once has broken ABI compatibility with user space tools. Was it an 
> accidental (but not corrected) mistake or was it deliberate? If the 
> latter, then, I guess, there must be some exceptions defining when ABI 
> compatibility can be not followed.

I don't think it has to be complete.  As long as the STGT people think
it's good enough, that's fine by me.

> 2. Currently STGT in the kernel is just 2 files, scsi_tgt_if.c and
> scsi_tgt_lib.c (with headers), + ibmvstgt driver. The C files define the 
> STGT interface in question. So, if we keep ABI compatibility with the 
> new target engine, we would have to keep those 2 files included in the 
> kernel,

This isn't really correct.  The ABI is defined by the headers not the
implementation.

>  which would effectively mean that STGT would stay in the kernel. 
> This would lead to the situation you are trying to avoid: 2 SCSI target 
> infrastructures in the kernel. Would it be OK?

If you mean is the marketing solution of wedging two products into the
kernel and calling it a single one going to fly, the answer is no.

James


