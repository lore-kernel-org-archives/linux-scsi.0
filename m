From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: aacraid broken in git
Date: Mon, 21 Apr 2008 17:42:52 -0700
Message-ID: <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
	 <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:59070 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999AbYDVAmy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 20:42:54 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1008622wra.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2008 17:42:53 -0700 (PDT)
In-Reply-To: <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

bisected to:

yhlu@mpk12-office-77-185:~/xx/xx/kernel/linux-2.6> git-bisect good
e6990c6448ca9359b6d4ad027c0a6efbf4379e64 is first bad commit
commit e6990c6448ca9359b6d4ad027c0a6efbf4379e64
Author: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Date:   Mon Apr 14 14:20:16 2008 -0400

    [SCSI] aacraid: Fix down_interruptible() to check the return value

    Instead of ignoring the return value in aac_fib_send() return 2 to
    indicate to the layers above that fib transmission was aborted due to
    timeout.

    Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 2f23bf33d76d6f37c558251003f88537c6e639fe
63d59091ca7ac527b5106540eea06d7b6649862d M      drivers
