From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: max GiB written per boot
Date: 06 Oct 2003 11:12:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065460336.10804.1.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de>  <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:28134 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264031AbTJFRM2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 13:12:28 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 978C91A21
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2003 11:12:27 -0600 (MDT)
In-Reply-To: <1064865746.4262.63.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I wish in the Subject line had mentioned so far I've tried writing GiB
only via usb where it dies, not elsewhere.  Today I returned after
leaving a drive idle for some days.  Nothing had appeared in the `dmesg`
meanwhile, but trying to talk to the drive provoked:

scsi: Device offlined - not ready after error recovery: host 0 channel 0
id 0 lun 0

Time to reboot I guess.  Pat LaVarre



