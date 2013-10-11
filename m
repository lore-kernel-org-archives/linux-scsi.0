From: yili <yilikernel@gmail.com>
Subject: Re: [Bug 62811] New: Don't Modify the scsi subcmd as LUN value when using VENDOR cmd
Date: Fri, 11 Oct 2013 05:16:04 +0000 (UTC)
Message-ID: <loom.20131011T070826-879@post.gmane.org>
References: <bug-62811-11613@https.bugzilla.kernel.org/> <1381426735.2109.4.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58751 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab3JRGZG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Oct 2013 02:25:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1VX3Ud-0004Fx-7i
	for linux-scsi@vger.kernel.org; Fri, 18 Oct 2013 08:25:03 +0200
Received: from 110.209.192.126 ([110.209.192.126])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2013 08:25:03 +0200
Received: from yilikernel by 110.209.192.126 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2013 08:25:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley <at> HansenPartnership.com> writes:





>>What are these vendor commands you'retrying to send that are out of spec?

---it is STEC Vendor Command code 0xA5

 

 >>>Should your device be reporting compliance with a SCSI level > 2?

---it is a usb flash device, i will try do the test.



Thanks for your advice.









