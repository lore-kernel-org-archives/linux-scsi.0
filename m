From: amrut h <h.amrut@gmail.com>
Subject: Regarding scsi_request
Date: Thu, 9 Feb 2006 18:23:34 +0900
Message-ID: <702b51100602090123n1534a775ia33d876f0abae88@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.200]:9033 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030305AbWBIJXf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 04:23:35 -0500
Received: by xproxy.gmail.com with SMTP id i30so84405wxd
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2006 01:23:34 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I have a query regarding the "scsi_request" data structure in linux kernel.
There is a comment on the top of definition of "scsi_request"
(linux/scsi/scsi_request.h) which reads:

http://lxr.linux.no/source/include/scsi/scsi_request.h#L19

13  * This is essentially a slimmed down version of Scsi_Cmnd.  The point of
14  * having this is that requests that are injected into the queue as result
15  * of things like ioctls and character devices shouldn't be using a
16  * Scsi_Cmnd until such a time that the command is actually at the head
17  * of the queue and being sent to the driver.
18  */


Please help me understand (or give me some pointer) why requests
issued through "scsi_request" only needs to go at the head of the
queue? Is it not possible to insert it in between queue (like after
sorting).

Kinldy let me know if i am missing something. I will appreciate if
somebody can give me some pointers to understand the above point

Thanks
~Amrut
