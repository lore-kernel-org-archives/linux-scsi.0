From: "Lee Xing" <lxing@Crossroads.com>
Subject: Returned info from mid-level to low-level driver
Date: Fri, 7 May 2004 13:57:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFE2@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:41674 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S263731AbUEGUCn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 16:02:43 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I would appreciate it if some one could give me a hint on the following question.

After the low-level driver registers a physical disk into mid-level driver, which (with high-level driver) presents it as both sd and sg special files (say /sdb and /sgc) in user space, can low-level driver know which sd/sg special files (for example, sda/sga or sdb/sgb, etc.) the disk is presented in user space?

Thanks,


Lee

