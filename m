From: Zach Brown <zab@redhat.com>
Subject: [PATCH RFC 0/3] simple copy offloading system call
Date: Fri, 10 Apr 2015 15:00:33 -0700
Message-ID: <1428703236-24735-1-git-send-email-zab@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello everyone!

Here's my current attempt at the most basic system call interface for
offloading copying between files.  The system call and vfs function
are relatively light wrappers around the file_operation method that
does the heavy lifting.

There was interest at LSF in getting the basic infrastructure merged
before worrying about adding behavioural flags and more complicated
implementations.  This series only offers a refactoring of the btrfs
clone ioctl as an example of an implementation of the file
copy_file_range method.

I've added support for copy_file_range() to xfs_io in xfsprogs and
have the start of an xfstest that tests the system call.  I'll send
those to fstests@.

So how does this look?

Do we want to merge this and let the NFS and block XCOPY patches add
their changes when they're ready?

- z
