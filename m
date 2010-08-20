From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
Date: Fri, 20 Aug 2010 03:02:40 -0700
Message-ID: <1282298560.30453.370.camel@haakon2.linux-iscsi.org>
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
	 <20100820163058P.fujita.tomonori@lab.ntt.co.jp>
	 <1282295674.30453.337.camel@haakon2.linux-iscsi.org>
	 <20100820184031L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:46585 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751466Ab0HTKGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 06:06:22 -0400
In-Reply-To: <20100820184031L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, hare@suse.de

On Fri, 2010-08-20 at 18:41 +0900, FUJITA Tomonori wrote:
> On Fri, 20 Aug 2010 02:14:34 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > I am pretty sure there are more important items to focus on inside from
> > this particuarly time-consuming and tedious cleanup, but am happy to
> 
> btw, it would be better to focus on the target core code first rather
> than its iscsi target driver?

Well, this is what was originally proposed for v2.6.35.  But considering
the LIO-Target namesake and it's full use of logic from the TCM/ConfigFS
v4 design, I believe that hch thought it made sense to include it
together moving forward with TCM Core now that we are moving forward
together.

> The mainline supports only ibm vscsi
> target now. So the target core code and its new vscsi driver can be
> merged to replace the current mainline target infrastructure and its
> vscsi driver, I think. the iscsi target driver is a "new" feature,
> which can be added later. No need to merge it with the target core
> code (of course, we can merge it together if possible).

I can plan to keep the posting of drivers/target/lio-target/ code
seperate, and after the upcoming public posting to linux-scsi for your
review of TCM core and TCM_Loop.   But perhaps at this point LIO-Target
should go in together with TCM Core and TCM_Loop once mnc can review the
software iSCSI target pieces..?

I am very happy to continue in the short term improving the LIO-Target
fabric module together with mnc to use mainline code and convention so
that we can ensure this piece is included together with TCM Core for
v2.6.37.  

Comments from other Linux/iSCSI folks is apperciated here..!

Best,

--nab


