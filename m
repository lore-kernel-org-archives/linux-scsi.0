From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] config: Make need for SCSI_CDROM clearer
Date: Wed, 1 Apr 2009 09:30:46 -0600
Message-ID: <20090401153046.GC8014@parisc-linux.org>
References: <20090401135952.22599.26719.stgit@localhost.localdomain> <20090401140014.22599.40007.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36385 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZDAPbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 11:31:05 -0400
Content-Disposition: inline
In-Reply-To: <20090401140014.22599.40007.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 01, 2009 at 03:00:18PM +0100, Alan Cox wrote:
> Mention ATAPI. We could insert an essay about libata and ide-scsi etc but
> the failure case is someone enables it which is just fine so keep it
> simple.
> 
> (Revised text from suggestion by Matthew Wilcox)
> 
> Closes #7736
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
