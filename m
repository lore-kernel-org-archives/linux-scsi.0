From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 13:05:55 -0400
Message-ID: <1184259955.3402.8.camel@localhost.localdomain>
References: <468BE4CE.80402@panasas.com> <4696287C.8060501@panasas.com>
	 <46962B74.9040909@panasas.com>  <20070712165805.GB19998@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50747 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbXGLRF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 13:05:57 -0400
In-Reply-To: <20070712165805.GB19998@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Oliver Neukum <oliver@neukum.name>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2007-07-12 at 09:58 -0700, Greg KH wrote:
> No objetion from me.  Care to resend it to me, and CC: the
> linux-usb-devel list also so that it is in a format that I can apply to
> the tree?

This will give you a cross tree dependency on scsi-misc-2.6 because of
the new data accessors ... if that's what you want to do?

James


