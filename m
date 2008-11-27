From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bug about mke2fs hang on AIC79 device
Date: Wed, 26 Nov 2008 22:09:10 -0600
Message-ID: <1227758950.3387.59.camel@localhost.localdomain>
References: <1227752318.2866.163.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49320 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYK0EJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 23:09:13 -0500
In-Reply-To: <1227752318.2866.163.camel@ymzhang>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: rjw@sisk.pl, michaelc@cs.wisc.edu, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2008-11-27 at 10:18 +0800, Zhang, Yanmin wrote:
> James,
> 
> 2.6.28-rc1 introduced a bug about scsi lib. We reported it at
> http://bugzilla.kernel.org/show_bug.cgi?id=11898.
> 
> Patch at http://bugzilla.kernel.org/show_bug.cgi?id=11898#c36 already fixes
> the bug. But 2.6.28-rc6 has no the patch. Although there is a performance issue,
> could you push the patch to upstream firstly? It seems the performance issue
> isn't related to the patch.

It is on upstream track ... it's here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=2a3a59e5c977654d3aad5bc11cc0aca2303a7f44

James


