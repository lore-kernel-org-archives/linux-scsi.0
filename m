From: Pat LaVarre <p.lavarre@ieee.org>
Subject: KiB/cdb limits
Date: 14 Oct 2003 17:45:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066175133.3399.12.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:56194 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261824AbTJNXpr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2003 19:45:47 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> I find some bugs "interesting".

I fell into that possibly fatal 'sg_dd bpt= count=' by mistyping a
command line designed to help me nail down what the KiB/cdb limit is.

Looked to me like cdb's didn't match command line for such command lines
as:

sudo sg_dd of=/dev/sg0 if=/dev/zero bs=2k bpt=$n count=$n

I thought I saw trouble arose somewhere down below something small, like
below 8 MiB = 0x1000 blocks per cdb.  (As you know, the t10 claim of cdb
max for ops like x2A Write 10 is xFFFF.)

If noone pops up here to beat me to the conclusion, I will myself try
this again in a few days and post to confirm/ deny this tentative first
impression of mine.

Pat LaVarre


