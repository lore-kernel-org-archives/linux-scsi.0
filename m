From: himanshu padmanabhi <himanshu.padmanabhi@gmail.com>
Subject: SCSI Reservation Conflicts errors
Date: Fri, 24 Apr 2009 13:07:04 +0530
Message-ID: <d5dce2210904240037n2f348d39sed568b6263ce07d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:14622 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZDXHhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 03:37:05 -0400
Received: by wf-out-1314.google.com with SMTP id 26so883437wfd.4
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2009 00:37:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I'm getting many reservation conflicts error messages on initiator
size when logged-in to the iSCSI target device. Please help me in
resolving this problem.

In the target size we have Persistent Reservation implemented and I am
adding Mode Pages support in the target side. So is it due to the this
persistent reservation? Or what is the reason of getting those
conflicts? Correct me if I am wrong.

I read the SPC-3 & SBC, but I am not cleared(understood) regarding
this Reservation Conflicts.

Please help me.

Thanks in advance.

---------------------------------
Thanks and Regards,
Himanshu Padmanabhi
