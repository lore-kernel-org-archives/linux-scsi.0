From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Wed, 19 Dec 2007 17:31:26 +1100
Message-ID: <200712191731.26512.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch series is the start of my attempt to simplify and make explicit
the chained scatterlist logic.

It's not complete: my SATA box boots and seems happy, but all the other
users of SCSI need to be updated and checked.  But I've gotten far enough
to believe it's worth persuing.

Cheers,
Rusty.
