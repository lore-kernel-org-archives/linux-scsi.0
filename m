From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [BK PATCH] bug fixes for scsi for linux-2.6.3-rc1
Date: 08 Feb 2004 11:39:51 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1076258392.2055.9.camel@mulgrave>
References: <1076256895.2055.6.camel@mulgrave>
	<20040208161911.GF24334@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040208161911.GF24334@parcelfarce.linux.theplanet.co.uk>
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2004-02-08 at 11:19, Matthew Wilcox wrote:
> Wasn't the mptscsih_exit problem already fixed by:
> 
> http://linux.bkbits.net:8080/linux-2.5/patch@1.1500.2.166?nav=index.html|ChangeSet@-3d|cset@1.1500.2.166
> 
> (went in via akpm 48 hours ago)

Hmm, missed that.

That would make the safest course of action to leave that in, and redo
the true fix after 2.6.3 is released.

Hang on, I'll redo the scsi-for-linus-2.6 tree.

James
