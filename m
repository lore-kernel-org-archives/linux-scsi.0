From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] [SCSI] ibmvscsi: Fix SCSI scanning
Date: Mon, 20 Jun 2011 19:58:12 +0200
Message-ID: <BANLkTim=EffOgBK=xrMfva-zOdX4fz-2Lg@mail.gmail.com>
References: <201106191348.40759.bvanassche@acm.org> <20110620114058.GA7372@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50260 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1FTR6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2011 13:58:32 -0400
Received: by vxb39 with SMTP id 39so1107497vxb.19
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 10:58:32 -0700 (PDT)
In-Reply-To: <20110620114058.GA7372@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Mon, Jun 20, 2011 at 1:40 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Jun 19, 2011 at 01:48:40PM +0200, Bart Van Assche wrote:
>> Avoid that SCSI scanning triggers creation of targets with a non-zero
>> channel number.
>
> Same comment as for the SRP one applies here as well.

If no kernel module parameters have been specified, max_channel is set
to three in the ibmvscsi driver. It's not clear to me why.

Bart.
