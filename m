From: Luben Tuikov <luben@splentec.com>
Subject: /proc/scsi/driver/hosts with same numeric???
Date: Wed, 29 May 2002 15:59:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CF53339.A21383FE@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g4TIwju20407
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2002 14:58:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello, this is what I see in /proc/scsi/some_driver:

total 0
-rw-r--r--    1 root     root            0 May 29 15:52 1
-rw-r--r--    1 root     root            0 May 29 15:52 2
-rw-r--r--    1 root     root            0 May 29 15:52 3  <- What is
-rw-r--r--    1 root     root            0 May 29 15:52 3  <-  the problem
-rw-r--r--    1 root     root            0 May 29 15:52 4  <-  here?
-rw-r--r--    1 root     root            0 May 29 15:52 4  <-
-rw-r--r--    1 root     root            0 May 29 15:52 5
-rw-r--r--    1 root     root            0 May 29 15:52 5
-rw-r--r--    1 root     root            0 May 29 15:52 6
-rw-r--r--    1 root     root            0 May 29 15:52 7
-rw-r--r--    1 root     root            0 May 29 15:52 8
-rw-r--r--    1 root     root            0 May 29 15:52 9

This driver scsi_registered() more than 10 hosts
and this happened? But as long as there are less
than 10 hosts, things seem ok.

How can I resolve this?

TIA,
-- 
Luben
