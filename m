From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 05 Jun 2008 01:22:49 -0400
Message-ID: <patchbomb.1212643369@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is just a proof of concept set of patches.  I'd like some
feedback before I spend more time on them.

At the Filesystem & Storage Workshop there was lots of discussion
about how to communicate I/O alignment, stripe width, etc. to the
filesystems so they could lay out things properly.

An addition to the up-and-coming version of the SCSI block protocol
features an inquiry page that hardware RAIDs can use to indicate
preferred I/O sizes for a given LUN.

This patch kit implements support for exporting those values in
/sys/block/.  I have implemented support for it in sd.c using the
Block Limits VPD and in MD using chunk size and stripe width.

The physical sector offset for the start of the "virtual" block device
is also exported.  This includes partitions so you can get the actual
physical start sector offset for - say - an MD device sitting on a
partitioned set of drives.

Comments and suggestions are welcome.

-- 
Martin K. Petersen	Oracle Linux Engineering



