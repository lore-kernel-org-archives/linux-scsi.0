From: Andrew Morton <akpm@digeo.com>
Subject: scsi in 2.5.48
Date: Mon, 18 Nov 2002 01:14:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD8AF65.BF2EF851@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


Appears to be DOA.  Just a simple mke2fs hangs in get_request_wait().
Running an `ls -lR' against an IDE disk gets it going again.  Seems
that the driver is failing to call into the elevator to fetch more
requests.  The unplug activity from the IDE reads is sufficient to
keep the SCSI driver limping along.

The driver is aic7xxx.
