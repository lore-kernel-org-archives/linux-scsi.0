From: Douglas Gilbert <dougg@torque.net>
Subject: Re: AIO for SG
Date: Sun, 09 Nov 2003 10:07:20 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FAD8538.9040304@torque.net>
References: <20031108070525.33552.qmail@web9501.mail.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:53262 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261661AbTKIAHt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Nov 2003 19:07:49 -0500
In-Reply-To: <20031108070525.33552.qmail@web9501.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Mark Lobo wrote:
> Guys,
> Is there a patch available which adds the aio
> interface to SG? (aio_read, aio_complete etc) 

Mark,
I have got one but it's against lk 2.5.69 . It is relatively
simple (i.e. supports aio_write and aio_complete but not
aio_read).

If I get time I'll send a patch against lk 2.6.0-test9 later
today.

Doug Gilbert

