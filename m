From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: clustering and 2.6
Date: Tue, 7 Sep 2004 11:12:54 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040907161254.GA23325@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S268170AbUIGQQq@vger.kernel.org>
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

All,
I'm having some issues when trying to use some clustering software when
running any 2.6.x kernel.
Basically, there are 2 nodes connected to 1 storage storage enclosure.
When node 1 comes up it reserves the volume(s) in the enclosure. When
node 2 comes up the read capacity fails as expected because of the 
SCSI reservation. However, if node 1 fails node 2 breaks the reservation,
but cannot register the disk. At this time we're assuming it's because the read
capacity failed and the size of the disk is zero blocks.

The SCSI mid-layer sets a bogus size on a device when read capacity fails.
Is this the preferred way to get around this issue? Seems like there
should be a better way.

Any input is greatly appreciated.

Thanks,
mikem
