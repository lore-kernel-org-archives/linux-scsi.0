From: James Bottomley <James.Bottomley@steeleye.com>
Subject: qla2xxx and feral ISP updates in their respective BK trees
Date: 18 Jun 2003 16:29:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1055971780.2075.484.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:29956 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265540AbTFRVPn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 17:15:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: mjacob@feral.com, Andrew Vasquez <praka@san.rr.com>, Andrew Morton <akpm@digeo.com>

I've updated both these trees

bk://linux-scsi.bkbits.net/scsi-isp-2.5
bk://linux-scsi.bkbits.net/scsi-qla2xxx-2.5

To their latest respective versions.

I've tried building these:

Qlogic:

qla2100 still refuses to build, which is the only FC card I have.  Also,
I could do with the directory tree being laid out in a standard fashion
(i.e. with the docs under Documentation/scsi like I've done in the BK
tree).

Feral:

Still giving me a HPMC on parisc in isp_reset.

James




