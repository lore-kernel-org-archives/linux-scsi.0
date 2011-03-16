From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: use list_move() instead of list_del()/list_add()
 combination
Date: Tue, 15 Mar 2011 21:52:09 -0400
Message-ID: <1300240329.13316.27.camel@mulgrave.site>
References: <1300229605-14499-5-git-send-email-kirill@shutemov.name>
	 <20110315235710.16992.33761.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1CPBwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2011 21:52:20 -0400
In-Reply-To: <20110315235710.16992.33761.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org

On Tue, 2011-03-15 at 16:57 -0700, Robert Love wrote:
> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: Robert Love <robert.w.love@intel.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: devel@open-fcoe.org

You can junk the cc's; they're mostly annotations for git-send-email

> Acked-by: Robert Love <robert.w.love@intel.com>

And this has to be Signed-off-by not Acked-by.  The reason is that
you've resent the patch (and altered it as you transmitted it) so that
makes you part of the signoff chain.  If you ack a patch, it means I can
pick it up from source and you as maintainer didn't actually touch it.

James


