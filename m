From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 25/33] Fix the reproducible oops in scsi
Date: Tue, 06 Feb 2007 09:22:06 -0600
Message-ID: <1170775326.3634.14.camel@mulgrave.il.steeleye.com>
References: <200702060040.l160e04u005027@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35332 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbXBFPW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2007 10:22:28 -0500
In-Reply-To: <200702060040.l160e04u005027@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, hirofumi@mail.parknet.co.jp, James.Smart@Emulex.Com

On Mon, 2007-02-05 at 16:38 -0800, akpm@linux-foundation.org wrote:
> From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> I got the oops after some hotplug events. And the similar oops can
> reproduce by the following step.

James Smart already pointed out that this fix isn't valid ... it's a
bandaid that doesn't fix the underlying problem.

James


