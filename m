From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: lsscsi version 0.19 beta
Date: Thu, 07 Dec 2006 11:45:02 -0600
Message-ID: <1165513502.4698.16.camel@mulgrave.il.steeleye.com>
References: <4577B06D.6060701@torque.net>
	 <1165508816.4698.2.camel@mulgrave.il.steeleye.com>
	 <4578465A.1070202@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44909 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162576AbWLGRpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 12:45:14 -0500
In-Reply-To: <4578465A.1070202@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-12-07 at 11:50 -0500, Douglas Gilbert wrote:
>   - cope with dropping of 'generic' symlink post lk 2.6.16

This one was supposed to be because you already have the class link:

generic@

and

scsi_generic:sg0@

So the necessary kernel changes (apart from the generic link removal)
are already there.

>   - anticipate the future removal of 'tape' symlink

I think this one is the same: st has its own class, which will have a
symlink.

James


