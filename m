From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: max GiB written per boot
Date: 06 Oct 2003 17:47:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065484077.2899.1.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de>  <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2>  <1065460336.10804.1.camel@patehci2>
	 <1065474044.6835.44.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:51591 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261762AbTJFXsG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 19:48:06 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id CC73A1757
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2003 17:48:05 -0600 (MDT)
In-Reply-To: <1065474044.6835.44.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

With usb2 in linux 2.6.0-test6 just now, ...

I find what works well for me is /etc/grub.conf:

title Red Hat Linux (2.6.0-test6)
        root (hd0,8)
        kernel /vmlinuz-2.6.0-test6 ro root=LABEL=/
        initrd /initrd-2.6.0-test6.img

What chokes often is:

title Red Hat Linux (2.6.0-test6)
        root (hd0,8)
        kernel /vmlinuz-2.6.0-test6 ro root=LABEL=/ hdc=ide-scsi
        initrd /initrd-2.6.0-test6.img

Having hdc=ide-scsi matter I think is a clue.

I don't yet know if this apparent correlation will hold up or not.

Pat LaVarre


