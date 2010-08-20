From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
Date: Fri, 20 Aug 2010 18:41:46 +0900
Message-ID: <20100820184031L.fujita.tomonori@lab.ntt.co.jp>
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
	<20100820163058P.fujita.tomonori@lab.ntt.co.jp>
	<1282295674.30453.337.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33369 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0HTJoa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 05:44:30 -0400
In-Reply-To: <1282295674.30453.337.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, hare@suse.de

On Fri, 20 Aug 2010 02:14:34 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> I am pretty sure there are more important items to focus on inside from
> this particuarly time-consuming and tedious cleanup, but am happy to

btw, it would be better to focus on the target core code first rather
than its iscsi target driver? The mainline supports only ibm vscsi
target now. So the target core code and its new vscsi driver can be
merged to replace the current mainline target infrastructure and its
vscsi driver, I think. the iscsi target driver is a "new" feature,
which can be added later. No need to merge it with the target core
code (of course, we can merge it together if possible).
