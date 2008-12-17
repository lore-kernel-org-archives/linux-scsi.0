From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 10:25:16 -0700
Message-ID: <20081217172516.GD19967@parisc-linux.org>
References: <20081217102048.a3c6426c1bfee0652ed014f32bc3b38e.0b45b81fab.wbe@email.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36587 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbYLQRZR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 12:25:17 -0500
Content-Disposition: inline
In-Reply-To: <20081217102048.a3c6426c1bfee0652ed014f32bc3b38e.0b45b81fab.wbe@email.secureserver.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bburk@extremeprotocol.com
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 17, 2008 at 10:20:48AM -0700, bburk@extremeprotocol.com wrote:
> Algorithm D is rather pointless.  Even if T10 added an Inquiry bit,
> there's no guarentee that all devices will support it, especially older
> devices made before the change so even if it got put in you STILL can't
> rely on it and will have to all back to other methods to get the
> information that you're looking for.

The UNMAP command is still in the draft stages.  Now is exactly the
right time to push for the TPE bit to be moved from RC16 to INQUIRY.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
