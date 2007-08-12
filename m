From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH] microtek: convert to use the data buffer accessors
Date: Mon, 13 Aug 2007 00:12:41 +0900
Message-ID: <20070811153044Z.tomof@acm.org>
References: <20070811072657A.tomof@acm.org>
	<E472128B1EB43941B4E7FB268020C89B0250BA18@riverside.int.panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:40104 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936511AbXHLPNi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Aug 2007 11:13:38 -0400
In-Reply-To: <E472128B1EB43941B4E7FB268020C89B0250BA18@riverside.int.panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, greg@kroah.com, fujita.tomonori@lab.ntt.co.jp

On Sun, 12 Aug 2007 11:01:20 -0400
"Harrosh, Boaz" <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote ...
> > Subject: [PATCH] microtek: convert to use the data buffer accessors
> >
> > - remove the unnecessary map_single path.
> > 
> > - convert to use the new accessors for the sg lists and the
> > parameters.
> > 
> > TODO: sg chaining support
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Is this not the same as the patch I sent at 2007-07-12
> http://marc.info/?l=linux-scsi&m=118424592500438&w=4
> 
> And was ACKed by one of the maintainers:
> http://marc.info/?l=linux-scsi&m=118426360825803&w=4
> 

Oops, I didn't realized that. Isn't the patch in scsi-misc,
scsi-pending, or scsi-fixes?
