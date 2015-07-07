From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 09/11] qla2xxx: Added interface to send ELS commands
 from driver.
Date: Tue, 07 Jul 2015 09:26:43 +0100
Message-ID: <1436257603.2238.4.camel@HansenPartnership.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
	 <1435250031-20525-10-git-send-email-himanshu.madhani@qlogic.com>
	 <20150703161418.GB32744@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48121 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbbGGI0s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 04:26:48 -0400
In-Reply-To: <20150703161418.GB32744@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Fri, 2015-07-03 at 09:14 -0700, Christoph Hellwig wrote:
> Why is this a binary attribute?  Needs an interface specific in
> Documentation/ABI/ to start with, and a Ccto stable seems very
> aggressive.

Right, adding an interface isn't a bug fix.

Can you separate this into patches which are essential bug fixes, which
can go immediately and those which are enhancements which wait for the
merge window?

Thanks,

James


