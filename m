From: Jan Vesely <jvesely@redhat.com>
Subject: [PATCH v4 0/2] block: Allow merging of tail pages into the last segment
Date: Fri, 12 Jul 2013 17:52:21 +0200
Message-ID: <1373644343-6671-1-git-send-email-jvesely@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Rob Evers <revers@redhat.com>, Tomas Henzl <thenzl@redhat.com>, Nikola Pajkovsky <npajkovs@redhat.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Don Howard <dhoward@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi

These patches modify __bio_add_page to accept pages that extent the last bio
segment. some drivers craft their buffers and rely on this behavior (see
message in patch 2 for details)


jan

v4: whitespace fixes to make checkpatch happy

v3: Use code from __blk_recalc_rq_segments to decide whether the page is
    mergeable, 

v2: modify a comment


