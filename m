From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: max GiB written per boot
Date: 06 Oct 2003 15:00:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065474044.6835.44.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de>  <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2>  <1065460336.10804.1.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:25811 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261664AbTJFVAy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 17:00:54 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id DC7E61816
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2003 15:00:53 -0600 (MDT)
In-Reply-To: <1065460336.10804.1.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Now commonly in -test6 I see such seemingly spontaneous events as:

scsi: Device offlined - not ready after error recovery: host 2 channel 0 id 0 lun 0
sr2: CDROM (ioctl) error, command: 0x00 00 00 00 00 00
sr?: sense =  0  0
Non-extended sense class 0 code 0x0
Raw sense data:0x00 0x00 0x00 0x00
cdrom: open failed.
SCSI error: host 2 id 0 lun 0 return code = 6070000
        Sense class 0, sense error 0, extended sense 0

Did I change some other significant variable?  Could be ...

I will rebuild my usb trace infrastructure and report again.

Pat LaVarre


