From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Mon, 10 Mar 2008 23:34:54 +0900
Message-ID: <20080310232133I.tomof@acm.org>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0803101114180.22505@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52870 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYCJOgY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 10:36:24 -0400
In-Reply-To: <Pine.LNX.4.64.0803101114180.22505@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.comtomof@acm.org

On Mon, 10 Mar 2008 11:14:49 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> On Sun, 9 Mar 2008, FUJITA Tomonori wrote:
> > This patchset adds new two helper functions to copy data between an SG
> > table and liner buffer, and converts severl LLDs to use them.
>             ^^^^^^^^^^^^
> a linear buffer (also in the patches).

Ah, a stupid typo. I'll fix it on the next round.

Thanks,
