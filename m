From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5117] New: Panic when accessing
 scsi-tapedrives with 4G-remap
Date: Thu, 25 Aug 2005 17:24:17 -0700
Message-ID: <20050825172417.217d56af.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:18862 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751074AbVHZA0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 20:26:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org, Kai.Makisara@kolumbus.fi
Cc: JF@vanbaarlen.demon.nl, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>



Begin forwarded message:

Date: Tue, 23 Aug 2005 12:53:38 -0700
From: bugme-daemon@kernel-bugs.osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5117] New: Panic when accessing scsi-tapedrives with 4G-remap


 http://bugzilla.kernel.org/show_bug.cgi?id=5117

            Summary: Panic when accessing scsi-tapedrives with 4G-remap
     Kernel Version: 2.6.12.5


Could this purely be a highmem problem?   Is the zero-copy DMA feature of
st.c known to work OK with x86 highmem?
