From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: SAS SMP pass-through documentation
Date: Thu, 11 Aug 2011 16:51:35 +0900 (JST)
Message-ID: <20110811.165135.1568838937885763665.fujita.tomonori@lab.ntt.co.jp>
References: <4E434E0E.40704@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:60956 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1HKHv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 03:51:26 -0400
In-Reply-To: <4E434E0E.40704@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, rdunlap@xenotime.net

On Wed, 10 Aug 2011 23:35:42 -0400
Douglas Gilbert <dgilbert@interlog.com> wrote:

> +The bsg driver
> +==============
> +bsg is an acronym for Block SCSI Generic. The "block" used in the name of
> +this driver is a little confusing since each bsg device node (e.g.
> +/dev/bsg/0:0:0:0 corresponds to /dev/sda which is a SATA disk on this
> +laptop) is actually a "char" device. The "block" term refers to the
> +kernel layer which conveys both blocked data and messages to lower layers

What 'blocked data' means?

The "block" term simply means that bsg is for the users of 'the block
layer' (including SCSI)?
