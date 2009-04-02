From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] Request for pulling exofs for 2.6.30
Date: Thu, 02 Apr 2009 12:44:52 -0400
Message-ID: <49D4EB84.6020100@garzik.org>
References: <49D4E70A.9090507@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761011AbZDBQqD@vger.kernel.org>
In-Reply-To: <49D4E70A.9090507@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, open-osd mailing-list <osd-dev@open-osd.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> which is available in the git repository at:
> 
>   git://git.open-osd.org/linux-open-osd.git for-linus
> 
> Boaz Harrosh (9):
>       exofs: Kbuild, Headers and osd utils
>       exofs: file and file_inode operations
>       exofs: symlink_inode and fast_symlink_inode operations
>       exofs: address_space_operations
>       exofs: dir_inode and directory operations
>       exofs: super_operations and file_system_type
>       exofs: export_operations
>       exofs: Documentation
>       fs: Add exofs to Kernel build



For what little weight I have in this area... ACK

But I would suggest _not_ splitting up the add-filesystem patch.  You 
really only want to split up this stuff for review.

The add-exofs change is one single logical change, and splitting it up 
across multiple changesets is not the most optimal nor bisect-safe approach.

	Jeff
