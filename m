From: Luben Tuikov <luben@splentec.com>
Subject: PCI bus mastering: restrictions?
Date: Wed, 19 Jun 2002 17:37:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D10F989.9F51DA29@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g5JLbAu13127
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2002 17:37:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

What are the restrictions on PCI Bus Mastering?

More specifically should each scatter-gather buffer
length be multiple of 4 bytes or mutliple of 512
or the hw sector size of the device?

TIA,
-- 
Luben
