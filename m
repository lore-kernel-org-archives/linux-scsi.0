From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH resend] Allow both megaraid drivers to be built
Date: Sun, 06 Nov 2005 12:47:59 -0600
Message-ID: <1131302879.3316.13.camel@mulgrave>
References: <436377F8.3060505@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:12945 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751050AbVKFSsL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Nov 2005 13:48:11 -0500
In-Reply-To: <436377F8.3060505@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: Neela.Kolli@engenio.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Sat, 2005-10-29 at 14:24 +0100, Daniel Drake wrote:
> Here's a rediff of a patch I sent at the end of August.
> 
> Rename megaraid to megaraid_legacy, changing sysfs name, module
> name, and the messages printed out via printk. I have left the procfs name as
> "megaraid" as presumably userspace tools rely on this.
> 
> Remove hardware ID's from megaraid_legacy which overlap with the newgen
> megaraid drivers.
> 
> Allow megaraid_legacy to be built alongside the newgen driver.
> 
> Instead of renaming the file locally and sending a huge unreviewable diff, 
> I've left the original filenames (megaraid.c and megaraid.h) in place. Please 
> use git-mv to rename these to megaraid_legacy.[ch] once you have applied this.

This looks fine to me.  I would, however, like input from the megaraid
maintainers, since it actually involves a name change.  However, if
there are no comments before we got -rc, I'll queue it for after 2.6.15

James


