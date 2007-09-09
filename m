From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 6/9] tgt: convert ibmvstgt and libsrp to use scsi_data_buffer
Date: Sun, 09 Sep 2007 18:09:02 +0300
Message-ID: <46E40C8E.5030906@panasas.com>
References: <46E3C6F3.6020506@panasas.com>	<20070909045722P.tomof@acm.org>	<46E40319.4030704@panasas.com> <20070909054929C.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15158 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757442AbXIIPJc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 11:09:32 -0400
In-Reply-To: <20070909054929C.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Sun, Sep 09 2007 at 17:38 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> On Sun, 09 Sep 2007 17:28:41 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>
>> I wish you could maybe clean up the unused stuff,
> 
> Well, I put them for Xen scsiback driver though now I could remove it.
> 
> 

Please do and we'll see after that.

