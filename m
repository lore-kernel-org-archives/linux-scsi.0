From: Christoph Hellwig <hch@lst.de>
Subject: remove exofs, the T10 OSD code and block/scsi bidi support V3
Date: Sun, 11 Nov 2018 14:32:03 +0100
Message-ID: <20181111133211.13926-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The only real user of the T10 OSD protocol, the pNFS object layout
driver never went to the point of having shipping products, and we
removed it 1.5 years ago.  Exofs is just a simple example without
real life users.

The code has been mostly unmaintained for years and is getting in the
way of block / SCSI changes, so I think it's finally time to drop it.

Quote from Boaz:

"As I said then. It is used in Universities for studies and experiments.
Every once in a while. I get an email with questions and reports.

But yes feel free to remove the all thing!!

I guess I can put it up on github. In a public tree.

Just that I will need to forward port it myself, til now you guys
been doing this for me ;-)"

Now the last time this caused a bit of a stir, but still no actual users,
not even for SG_IO passthrough commands.  So here we go again, this time
including removing everything in the scsi and block layer supporting it,
and thus shrinking struct request.
