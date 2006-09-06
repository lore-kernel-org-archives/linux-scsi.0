From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: git-scsi-misc oops
Date: Wed, 06 Sep 2006 08:52:43 -0500
Message-ID: <1157550763.3469.0.camel@mulgrave.il.steeleye.com>
References: <20060905231933.3371cd8a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61577 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751046AbWIFNwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 09:52:55 -0400
In-Reply-To: <20060905231933.3371cd8a.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-09-05 at 23:19 -0700, Andrew Morton wrote:
> aic79xxx isn't happy.  Using
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git,
> no other patches applied.

Oh ... let me guess ... you built it into the kernel, not as a module?

James


