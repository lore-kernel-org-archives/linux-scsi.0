From: Alex Deucher <alexdeucher@gmail.com>
Subject: Connection to SAN times out after a few days
Date: Thu, 19 May 2005 15:26:11 -0400
Message-ID: <a728f9f90505191226655f26a1@mail.gmail.com>
Reply-To: Alex Deucher <alexdeucher@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.194]:18716 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261228AbVEST0M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 15:26:12 -0400
Received: by rproxy.gmail.com with SMTP id a41so324282rng
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2005 12:26:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have Nexsan ATAbeast SAN connected to an AMD64 (sun v20z) and
SPARC64 (sun 220R) server using lpfc HBAs (using the in kernel lpfc
driver, kernel 2.6.12-rc4).  About once every 4-5 days, the server
loses its connection to the SAN and I get these messages in my log:
May 19 09:01:08 nutcracker scsi1 (0:0): rejecting I/O to offline device
May 19 09:01:08 nutcracker metapage_read_end_io: I/O error
May 19 09:01:08 nutcracker scsi1 (0:0): rejecting I/O to offline device
May 19 09:01:08 nutcracker metapage_read_end_io: I/O error
May 19 09:01:08 nutcracker ERROR: (device dm-4): DT_GETPAGE: dtree page corrupt
May 19 09:01:09 nutcracker scsi1 (0:0): rejecting I/O to offline device
May 19 09:01:09 nutcracker metapage_read_end_io: I/O error
May 19 09:01:09 nutcracker ERROR: (device dm-4): DT_GETPAGE: dtree page corrupt

Nothing unusual shows up in the SAN logs.  I've already adjusted the
cache flushing on the SAN and changed the scsi timeouts to 45 seconds.
 I asked emulex about it, but I'm wondering if this is something in
the scsi layer.  Has anyone else had similar problems or know what the
problem may be?

Thanks,

Alex
