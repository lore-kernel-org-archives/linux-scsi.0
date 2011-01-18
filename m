From: Lukas Czerner <lczerner@redhat.com>
Subject: [LSF/MM TOPIC][ATTEND] Discard support review/update and benchmark
 numbers
Date: Tue, 18 Jan 2011 12:53:54 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101181244570.2695@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Agenda topic proposal:
----------------------

In the past year a lot of work has been done towards more efficient
Linux discard support. We would like to review all the efforts in
this area and summarize where we stand now and what can be done in
the near future. Show the options we have and how they perform with
various classes of devices in different benchmarks and present some
numbers. Last, but not least we think that we are at the point where
hardware vendors should join in the discussion. At this matter we
would like to outline the options they have to test the Linux discard
stack with their hardware and make it all cooperate easily.

Authors:
--------

Christoph Hellwig <hch@infradead.org>

Christoph Hellwig has been working with Linux for more than 10 years,
soon focussing on kernel-related issues. He has also been involved in
various other Free Software projects. After a number of smaller network
administration and programming contracts he worked for Caldera's German
development subsidiary on various kernel and userlevel aspects of the
OpenLinux distribution and later joined the filesystem and storage group
at SGI, focussing on XFS for Linux. Since 2004 he has been self-employed
doing contracting, consulting and training in the Linux Kernel and Storage
world.

Lukas Czerner <lczerner@redhat.com>

Lukas is a software engineer with Red Hat, Inc, where he works mainly on
Ext4 filesystem. He has been involved in performance evaluation of Linux
discard support and was examining of alternative approaches which led to
establishing the interface for filesystem batched discard support aka
FITRIM as well as implementation for Ext4/3 filesystems.


Thanks!
-Lukas
