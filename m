From: Stelian Pop <stelian.pop@fr.alcove.com>
Subject: Re: optional features error - promise raid card fs
Date: Fri, 7 Feb 2003 16:37:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030207153727.GB11112@cedar.alcove-fr>
References: <Pine.LNX.4.44.0302070635540.32473-100000@mydns2.compustrat.com>
Reply-To: Stelian Pop <stelian.pop@fr.alcove.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302070635540.32473-100000@mydns2.compustrat.com>
List-Id: linux-scsi@vger.kernel.org
To: Mailing Lists <thelittleprince-lists@asteroid-b612.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Feb 07, 2003 at 07:15:16AM -0800, Mailing Lists wrote:

> * tune2fs -l /dev/sda3
[...]
> Filesystem features:      has_journal filetype needs_recovery sparse_super

In order to properly convert a filesystem from ext3 back to ext2 you
need to remove the has_journal attribute from the superblock:
	# umount /dev/sda3
	# tune2fs -O ^has_journal /dev/sda3
	# e2fsck /dev/sda3

Stelian.
-- 
Stelian Pop <stelian.pop@fr.alcove.com>
Alcove - http://www.alcove.com
