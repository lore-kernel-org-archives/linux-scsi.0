From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/1] Apply segment size and segment boundary to integrity data
Date: Thu, 15 Jul 2010 17:34:10 +0200
Message-ID: <20100715153410.774329000@de.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

While experimenting with the data integrity support in the Linux
kernel, i found that the block layer integrity code can send integrity
data segments for a request that do not adhere to the queue limits. 
The integrity data segment can be larger than queue_max_segment_size
and the segment does not adhere to the queue_segment_boundary.

It appears to me that the right way would be to apply the same
restrictions that are in place for data segments also to integrity
data segments. The patch works for my experiments and applies on top
of the current Linux tree (2.6.35-rc5).

Christof
