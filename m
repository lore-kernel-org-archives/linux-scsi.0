From: Luben Tuikov <luben@splentec.com>
Subject: Questions on scsi-scan.c::scsi_get_device_id()
Date: Thu, 08 Aug 2002 15:21:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D52C4C4.F3EBDAE9@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g78JLbs15338
	for <linux-scsi@vger.kernel.org>; Thu, 8 Aug 2002 15:21:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Is it possible that the

	idtype = 3;
	while (idtype > 0) {
		<< BODY >>
		idtype--;
	}

loop in scsi_scan.c :: scsi_get_device() be turned
into a for loop using the proverbial, classical
example. ( <<BODY>> is longer than to justify the
current use and as such using a for loop would make
the intentions of the code clear at the top. )

Is it imperative that 80 column limit is imposed?

TIA,
-- 
Luben
