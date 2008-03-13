From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Thu, 13 Mar 2008 09:18:48 +0900
Message-ID: <20080313091848X.tomof@acm.org>
References: <20080312092856P.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.44L0.0803121202150.4595-100000@iolanthe.rowland.org>
	<20080313090258Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:44198 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYCMAWx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 20:22:53 -0400
In-Reply-To: <20080313090258Z.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

On Thu, 13 Mar 2008 09:03:26 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> > There are two problems.  One is the types of the arguments and return 
> > value.
> 
> They should be ok with the updated patch.
> 
> 
> > The other is that local interrupts need to be disabled.
> 
> Can you disable local interrupts here?

I meant, are you fine with disabling local interrupts here?

If you don't like that, we need to add another argument and seveal
'if' to sg_copy_buffer. But I prefer to keep it simple.


> Basically, the APIs are used in queuecommand.
