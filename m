From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 8] I/O topology patch kit
Date: Thu, 23 Apr 2009 01:29:27 -0400
Message-ID: <patchbomb.1240464567__6336.24199913374$1240465864$gmane$org@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:54635 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZDWFtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 01:49:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org


Here is another take of my I/O topology patches.  There was quite a bit
of discussion at the FS & Storage workshop about the need to describe
regions.  Sanity prevailed, and the region code and associated
complexity is now gone.

There are changes in various subsystems, all depending on the block
layer bits.  To avoid breaking bisection I ended up creating a new block
layer stacking function.  Once all patches are in place we can deprecate
the old one.

Comments and suggestions welcome.

-- 
Martin K. Petersen	Oracle Linux Engineering


