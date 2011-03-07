From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: target: Remaining for-38 regression bugfix
Date: Mon, 07 Mar 2011 15:25:55 -0800
Message-ID: <1299540355.19683.344.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Hi James,

At this point there is still one critical regression bugfix caused by
the target_core_cdb.c v4.0 refactoring from Christoph that needs to go
in ASAP.  Please make sure the following patch is included into your
final for-38 scsi-rc-fixes pull request for Linus.

target: Fix READ_CAPACITY_16 regression
http://marc.info/?l=linux-kernel&m=129911001806783&w=2

Please let me know if you have any questions,

--nab
