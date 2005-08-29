From: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] Allow both megaraid drivers to be built
Date: Mon, 29 Aug 2005 18:30:23 +0100
Message-ID: <4313462F.9030904@gentoo.org>
References: <431320AB.7010303@gentoo.org> <20050829150209.GA5563@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:63325 "EHLO
	mta07-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1751138AbVH2RYu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:24:50 -0400
In-Reply-To: <20050829150209.GA5563@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, sreenib@lsil.com, sju@lsil.com

Christoph Hellwig wrote:
> ifdef on other drivers is bogus, please remove the pci ids completely
> from the old driver.  It'd probably be a good idea to rename it to
> megaraid_legacy aswell.  I've also asked the LSI Engineers whether they
> could help identifying what code could be remove when only supporting
> the two oldes chips but haven't gotten a reply yet.  I hope they'll
> be able to answer when they're less busy.

Thanks for the feedback. Here's a new patch.



Rename megaraid to megaraid_legacy, changing the filenames, sysfs name, module 
name, and the messages printed out via printk. I have left the procfs name as 
"megaraid" as presumably userspace tools rely on this.

Remove hardware ID's from megaraid_legacy which overlap with the newgen 
megaraid drivers.

Allow megaraid_legacy to be built alongside the newgen driver.

Signed-off-by: Daniel Drake <dsd@gentoo.org>



As the patch is large (300K) I am not including it in this mail. You can get 
it here:

	http://dev.gentoo.org/~dsd/megaraid_legacy.patch

Thanks,
Daniel
