From: "David Peterson \(Eng\)" <david_peterson@cnt.com>
Subject: SSC-2 support in Linux
Date: Tue, 14 Sep 2004 18:03:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <82C736F456CA3E4EA3D0DC6CC31AA5CB01651157@esply09.cnt.ad.cnt.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatehider.cnt.com ([139.93.128.13]:44611 "EHLO esply07.cnt.com")
	by vger.kernel.org with ESMTP id S267705AbUINXDj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 19:03:39 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

I'd like to hear from anyone interested, or has looked into, adding
support for SSC-2 (SCSI Stream Commands -2, i.e., tape devices) explicit
address mode into the Linux OS.

In summary, SSC-2 explicit address mode enables for tape devices:
- robust tagged command queuing
- multi-path I/O
- enhanced error detection and recovery

Thanks...Dave
