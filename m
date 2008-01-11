From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] aacraid: add call to flush_kernel_dcache_page for
	architectures that require it (take 2)
Date: Fri, 11 Jan 2008 13:56:53 -0600
Message-ID: <1200081413.3286.67.camel@localhost.localdomain>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
	 <20071101173221.2e1fea42.sfr@canb.auug.org.au>
	 <jefxzqqeha.fsf@sykes.suse.de>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC622@ADPE2K703.adaptec.com>
	 <1200069662.3286.21.camel@localhost.localdomain>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F437E443B7@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55545 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761638AbYAKT46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 14:56:58 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F437E443B7@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


On Fri, 2008-01-11 at 11:46 -0800, Salyzyn, Mark wrote:
> The reason for the guard was for Linux Distributions that had limited
> their list of exported APIs on architectures that did *not* require
> the flush_kernel_dcache_page ... Sorry for not filtering out
> Distribution kernel issues into the list! :-)

That's OK, but you might want to update your distro patch.  The correct
guard check is ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE for them ...

> Dropped guard in the enclosed patch.


Thanks!

James


