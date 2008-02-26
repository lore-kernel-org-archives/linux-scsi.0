From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: Patch added to scsi-rc-fixes-2.6:  [SCSI] arcmsr: fix
	messageallocation
Date: Tue, 26 Feb 2008 08:14:04 -0800
Message-ID: <1204042444.3254.72.camel@localhost.localdomain>
References: <000d01c87830$23d84b00$8800a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38190 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbYBZQOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 11:14:10 -0500
In-Reply-To: <000d01c87830$23d84b00$8800a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: 'Daniel Drake' <dsd@gentoo.org>, linux-scsi@vger.kernel.org

On Tue, 2008-02-26 at 12:29 +0800, nickcheng wrote:
> James,
> Appreciate for your answer.
> One more question: do you think there are any compatibility issues on
> kmalloc/kfree pair?
> I just trace the kernel code. It looks like it would not.
> But I am not quite sure absolutely.
> May I have your comments?

You mean does kmalloc/kfree obey the same rules as the coherent
allocators in all regards except coherence ... pretty much, yes.  There
are some technical differences at the bottom in terms of page alignment,
but nothing you need to worry about.

James


