From: Luben Tuikov <luben@splentec.com>
Subject: sense buffer length for REQUEST SENSE?
Date: Fri, 26 Jul 2002 23:03:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D420D77.A4633D9C@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g6R33Is21463
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2002 23:03:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The sense buffer size is 64 bytes.

According to SAM-3, to make sure that that an application
client has gotten all the sense data the sense buffer
should be 252 bytes.

How safe am I to actually set the allocation length
to 252 bytes? (in terms of borken hardware devices, etc.)

-- 
Luben
