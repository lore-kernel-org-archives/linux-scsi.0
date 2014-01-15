From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [LSF/MM TOPIC] copy offloading
Date: Wed, 15 Jan 2014 12:27:54 -0800
Message-ID: <20140115202754.GL8102@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Discussing copy offloading at LSF is appropriate because it can involve
so many layers of the stack:

 - high level syscall interface
 - in-kernel high level entry point for nfsd 
 - fs specific implementations (btrfs and ocfs2 cow, nfs) 
 - vfs helper for offloading block copies for ext*,xfs
 - bio offload requests for cow block devices like bcache/dm-cache
 - encoding offload bios into scsi reqs
 - processing virt guest device offload requests with host syscalls

Getting the user and in-kernel interfaces right to support all these
moving parts has proven tricky.  The more input, the better.

It's been a while since I sent out a refreshed version of the series.
That'll be remedied before LSF rolls around :). 

- z
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
