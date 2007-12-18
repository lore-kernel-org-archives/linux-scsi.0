From: "Mulyadi Santosa" <mulyadi.santosa@gmail.com>
Subject: Re: In which case EWOULDBLOCK is set while a write operation
Date: Tue, 18 Dec 2007 19:46:11 +0700
Message-ID: <f284c33d0712180446m462ed181x1e19ef16112b8d53@mail.gmail.com>
References: <200712180553.lBI5rQgD004427@arlmail.patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:43765 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbXLRMqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2007 07:46:13 -0500
Received: by el-out-1112.google.com with SMTP id v27so447291ele.23
        for <linux-scsi@vger.kernel.org>; Tue, 18 Dec 2007 04:46:12 -0800 (PST)
In-Reply-To: <200712180553.lBI5rQgD004427@arlmail.patni.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saquib Imam <saquib.imam@patni.com>
Cc: linux-scsi@vger.kernel.org

Hi..

> In which case EWOULDBLOCK / EAGAIN is set while a write operation ?

i think it will happen if you use O_NONBLOCK but writing operation
itself will clearly block (for numerous reasons e.g block needs to be
allocated first and so on).

> Can any one give detailed processing of a write operation for a file system
> with journaling , like EXT3 File System.

better grab book like Understanding the Linux kernel 3rd edition or
Linux Device Driver 3rd edition. It is explained quite extensively
there.

regards,

Mulyadi.
