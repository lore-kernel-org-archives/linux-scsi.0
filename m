From: "Fajun Chen" <fajunchen@gmail.com>
Subject: sg reserved buffer sharing
Date: Thu, 27 Mar 2008 15:30:08 -0700
Message-ID: <8202f4270803271530j244edb2ctb31c6bb76aafa16a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:22119 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYC0WaT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 18:30:19 -0400
Received: by wx-out-0506.google.com with SMTP id h31so4858483wxd.4
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 15:30:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net

Hi All,

We use sg's reserved buffer through mmap in kernel 2.6.18.  This has
been working well for us until a new requirement comes up.  We need
the capability to share the buffer across processes.  For instance,
after a command is completed in process 1, we want to dump out the
buffer in process 2.  Is there any way to do this? Based on sg howto
document, sg reserved buffer is allocated per sg file descriptor.

Thanks,
Fajun
