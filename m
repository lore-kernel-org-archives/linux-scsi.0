From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi_device_reprobe compile failure in scsi_misc_2.6
Date: Mon, 02 Oct 2006 14:02:57 -0500
Message-ID: <1159815777.3460.39.camel@mulgrave.il.steeleye.com>
References: <1159813997.3795.7.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:31888 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965311AbWJBTDD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 15:03:03 -0400
In-Reply-To: <1159813997.3795.7.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-10-02 at 11:33 -0700, Mark Haverkamp wrote:
> It looks like a recent patch to scsi_device_reprobe() has introduced a
> compile error.  It now checks the return value of device_reprobe() but
> the patch to make device_reprobe() return int hasn't been applied to
> the
> tree yet.

If you just pull scsi-misc-2.6 into the current linus git head,
everything will work.

James


