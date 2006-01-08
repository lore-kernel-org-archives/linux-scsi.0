From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: SG_GET_ACCESS_COUNT ioctl problem
Date: Sun, 08 Jan 2006 08:54:40 -0500
Message-ID: <43C119A0.8070304@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-05-smtplb.tampabay.rr.com ([65.32.5.135]:39362 "EHLO
	ms-smtp-05.tampabay.rr.com") by vger.kernel.org with ESMTP
	id S1161056AbWAHNym (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Jan 2006 08:54:42 -0500
Received: from [10.10.10.100] (158.244.118.70.cfl.res.rr.com [70.118.244.158])
	by ms-smtp-05.tampabay.rr.com (8.12.10/8.12.7) with ESMTP id k08DseeP013297
	for <linux-scsi@vger.kernel.org>; Sun, 8 Jan 2006 08:54:40 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In the 2.4 kernel (not using devfs) the SG_GET_ACCESS_COUNT ioctl to an
sg device would report the correct/expected usage count when issued to a
sd disc that was mounted, accounting for the mount by the system. The
2.6 kernel does not. Is this now the expected behavior or is this a bug?

Mark

