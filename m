From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 21 Nov 2003 10:42:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujvfpdwu4f.fsf@chaapala-lnx2.cisco.com>
References: <200310231734.10263.krmurthy@cisco.com>
	<20031027153932.A16679@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:53684 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S264370AbTKUQmo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 11:42:44 -0500
In-Reply-To: <20031027153932.A16679@infradead.org> (Christoph Hellwig's
 message of "Mon, 27 Oct 2003 15:39:32 +0000")
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Krishna Murthy <krmurthy@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Mon, 27 Oct 2003, Christoph Hellwig said:
> 
> highlevel:
> 	- kill md5.c and iscsi-crc.c and use common cryptoapi
> 	md5 / common crc code instead.

md5: That appears straight-forward, and has been implemented, subject
     to testing.  SELECT CRYPTO and SELECT MD5 makes it available
     in the kernel.

crc32: Ah, the iSCSI crc32 uses a different polynomial (stronger) than
     Ethernet and the rest.  We argued during the RFC process for just
     using Ethernet's as good enough, but were voted down.  So we are
     stuck with a separate implementation in this case.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
     Well, looks like hypocrisy is back on the airwaves.
       C'mon, Rush!  Do the crime, do the time, right?
