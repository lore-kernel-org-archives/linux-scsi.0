From: "Metathronius Galabant" <m.galabant@googlemail.com>
Subject: aacraid driver incomplete regarding info + logging
Date: Tue, 10 Oct 2006 14:00:07 +0200
Message-ID: <1b270aae0610100500j538860ecs9d4f3f4a4b9d490f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:47933 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S964956AbWJJMAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 08:00:09 -0400
Received: by wx-out-0506.google.com with SMTP id s14so1807885wxc
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2006 05:00:08 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear all,

when using the aacraid driver I found out that the driver is grossly incomplete.

1) there is no /proc/scsi/aacraid/... interface about the volume/adapter status
2) there is no printk() when a raid fails, is rebuilding, has finished
rebuilding etc.

Are there any patches that go into this direction?
Else I *might* find time to contribute some code if I can get some guidance.

Cheers,
M
