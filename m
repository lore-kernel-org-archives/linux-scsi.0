From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] [SCSI] ibmvscsi: Fix SCSI scanning
Date: Mon, 20 Jun 2011 14:10:24 -0500
Message-ID: <4DFF9B20.8040100@linux.vnet.ibm.com>
References: <201106191348.40759.bvanassche@acm.org> <20110620114058.GA7372@infradead.org> <BANLkTim=EffOgBK=xrMfva-zOdX4fz-2Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52714 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1FTTK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 15:10:29 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5KIk7dB023501
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 14:46:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5KJASwL130846
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 15:10:28 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5KFAEwO014217
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2011 12:10:16 -0300
In-Reply-To: <BANLkTim=EffOgBK=xrMfva-zOdX4fz-2Lg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>

On 06/20/2011 12:58 PM, Bart Van Assche wrote:
> On Mon, Jun 20, 2011 at 1:40 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Sun, Jun 19, 2011 at 01:48:40PM +0200, Bart Van Assche wrote:
>>> Avoid that SCSI scanning triggers creation of targets with a non-zero
>>> channel number.
>>
>> Same comment as for the SRP one applies here as well.
> 
> If no kernel module parameters have been specified, max_channel is set
> to three in the ibmvscsi driver. It's not clear to me why.

It could be set as high as 16 in order to support the full 3 bits worth
of bus values as defined in Logical Unit Addressing model in SAM, but
3 is generally sufficient for most users as it allows for 64 targets *
3 buses = 192 virtual scsi targets.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


