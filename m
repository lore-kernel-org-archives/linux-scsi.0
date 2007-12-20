From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/5] sg_ring for scsi
Date: Thu, 20 Dec 2007 16:45:18 +1100
Message-ID: <200712201645.19035.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754925AbXLTFph@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>
List-Id: linux-scsi@vger.kernel.org

OK, some fixes since last time, as I wade through more SCSI drivers.  Some 
drivers use "use_sg" as a flag to know whether the request_buffer is a 
scatterlist: I don't need the counter, but I still need the flag, so I fixed 
that in a more intuitive way (an explicit ->sg pointer in the cmd).

Also, I've updated and tested scsi_debug, after Douglas's excellent 
suggestion.

(I just found out about struct scsi_pointer, so I'm off to update that now, 
too).

Cheers,
Rusty.
