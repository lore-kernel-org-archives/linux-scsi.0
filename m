From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF guard tag on
 ext2 write)
Date: Thu, 03 Jun 2010 19:09:52 +0300
Message-ID: <4C07D3D0.8010500@panasas.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lsf10-pc@lists.linuxfoundation.org, Nick
List-Id: linux-scsi@vger.kernel.org

[Topic]
How to not let pages change while in IO

[Abstract]
As seen in a long thread on the fsdvel scsi mailing lists. Lots of
people have headaches and sleep less nights because individual pages
can change while in IO and/or DMA. Though each one as slightly different
needs, the mechanics look to be the same.

People that care:
- Mirror and RAID people that need on disk consistency.
- Network storage that wants data checksum.
- DIF/DIX people
- ...

I for one know nothing of the subject but am a RAID person and would
like a solution that does not force me to copy the complete data load.

Please lets get all the VM VFS and drivers people in one room and see
if we can have a Linux solution to this problem

Boaz
