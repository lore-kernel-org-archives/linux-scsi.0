From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH -next] osd_uld: fix printk format warning
Date: Mon, 4 May 2009 19:30:55 +0100
Message-ID: <20090504183055.GI8633@ZenIV.linux.org.uk>
References: <20090429092631.a76e79c5.randy.dunlap@oracle.com> <20090429185128.GN8633@ZenIV.linux.org.uk> <49F97DAF.2050605@panasas.com> <20090503183541.GX8633@ZenIV.linux.org.uk> <20090503190238.GZ8633@ZenIV.linux.org.uk> <49FF133D.9020603@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:34754 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZEDSa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 14:30:59 -0400
Content-Disposition: inline
In-Reply-To: <49FF133D.9020603@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-scsi@vger.kernel.org

On Mon, May 04, 2009 at 07:09:33PM +0300, Boaz Harrosh wrote:
 
> Thanks Al, very much. It is exactly what I was hoping for, but could not
> figure out for myself.
> 
> I will give it an hard testing ASAP, and will queue it for next kernel (2.6.31).
> 
> Can I take the osd cleanup hunk form your patchset + Randy's fix and serialize them
> together with this through the scsi tree? (Together with the rest of the osd patches)
> Is your patchset dependent on the osd bit for removal of some code? If so then I'll
> send this patch through your tree so not to have conflicts in linux-next.
 
Actually, git should manage such merge just fine, so -next is probably not
a concern.  In any case, if there are any problems with the merge I can
take that chunk out - nothing depends on it yet in the public queue.  Or
I could take this incremental in vfs tree - also not a problem...
