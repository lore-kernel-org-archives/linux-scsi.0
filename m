From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [LSF/MM ATTEND]  storage topics plus container filesystems and IMA
Date: Fri, 13 Jan 2017 11:46:12 -0800
Message-ID: <1484336772.2527.40.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

I'd like to attend LSF/MM mostly to participate in the storage topics
discussion, but also because containers is starting to need some
features from the VFS.  Hopefully the container uid shifting is mostly
sorted out by the superblock user namespace, and I should have patches
to demonstrate this in shiftfs this month.  However, trusted containers
are also becoming an issue and, since containers are file based, not
image based, we really need to sort out the IMA interfaces to be
correctly integrated into the VFS, so I'd like to be present in those
discussions as well.

James

