From: Mailing Lists <thelittleprince-lists@asteroid-b612.org>
Subject: Re: optional features error - promise raid card fs
Date: Mon, 10 Feb 2003 05:29:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302100528340.15206-100000@mydns2.compustrat.com>
References: <20030207153727.GB11112@cedar.alcove-fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030207153727.GB11112@cedar.alcove-fr>
List-Id: linux-scsi@vger.kernel.org
To: Stelian Pop <stelian.pop@fr.alcove.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 7 Feb 2003, Stelian Pop wrote:

> On Fri, Feb 07, 2003 at 07:15:16AM -0800, Mailing Lists wrote:
> 
> > * tune2fs -l /dev/sda3
> [...]
> > Filesystem features:      has_journal filetype needs_recovery sparse_super
> 
> In order to properly convert a filesystem from ext3 back to ext2 you
> need to remove the has_journal attribute from the superblock:
> 	# umount /dev/sda3
> 	# tune2fs -O ^has_journal /dev/sda3
> 	# e2fsck /dev/sda3
> 

doh! *slaps forehead*
stupid stupid..thank you, this did it.

-Tony


