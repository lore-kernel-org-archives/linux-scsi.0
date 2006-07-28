From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/3] scsi : megaraid_{mm,mbox}: 64-bit DMA capability
	checker
Date: Fri, 28 Jul 2006 13:20:54 -0500
Message-ID: <1154110854.9447.41.camel@mulgrave.il.steeleye.com>
References: <890BF3111FB9484E9526987D912B261932E2CF@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57743 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161219AbWG1SVI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jul 2006 14:21:08 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261932E2CF@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: vvs@sw.ru, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@engenio.com>, "Yang, Bo" <Bo.Yang@engenio.com>

On Tue, 2006-07-25 at 08:44 -0600, Ju, Seokmann wrote:
> This patch contains 
> - a fix for 64-bit DMA capability check in megaraid_{mm,mbox} driver.
> - includes changes (going back to 32-bit DMA mask if 64-bit DMA mask
> failes) suggested by James with previous patch.
> - addition of SATA 150-4/6 as commented by Vasily Averin.

Warning: trailing whitespace in lines 885,889 of
drivers/scsi/megaraid/megaraid_mbox.c
Warning: trailing whitespace in lines
13,15,16,19,21,22,26,27,29,31,33,37,39,46 of
Documentation/scsi/ChangeLog.megaraid

I'll fix it up this time, but in future could you trailing whitespace
check your patches? (git will do this for you).

Also, when you do a git workflow, the body of the email becomes the
commit message, so things like this

> This is a third patch which follows prevous two patches ([PATCH 1/3]
> and
> [PATCH 2/3]).

while no doubt being useful to the members of linux-scsi who are
actually unable to count aren't actually useful in commit messages.

James


