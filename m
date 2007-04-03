From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aacraid: [Fastboot] Panics for AACRAID
	driverduring'insmod' for kexec test [take 4]
Date: Tue, 03 Apr 2007 11:09:54 -0500
Message-ID: <1175616594.3645.26.camel@mulgrave.il.steeleye.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF017AA267@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42299 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753521AbXDCQK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2007 12:10:28 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF017AA267@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Judith Lebzelter <judith@linux-foundation.org>, vgoyal@in.ibm.com, linux-scsi@vger.kernel.org

On Tue, 2007-04-03 at 11:58 -0400, Salyzyn, Mark wrote:
> I will do you one better, James, I will slip in a little cleanup in
> sa.c (support file for the old PPC based ARC cards) where I discovered
> the restart platform function was ALSO left unset which could result
> in similar pain of null pointer discovery.

Actually, for 2.6.21-rc5 could I just have the two strict bug fixes for
the potential oops you spotted ...  I should really be adding feature
changes or cleanups at this stage of the kernel release.

I can put all the rest into scsi-misc for post 2.6.21

Thanks,

James


