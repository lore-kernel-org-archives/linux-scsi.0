From: Joe Scsi <joe.scsi@gmail.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Tue, 15 Feb 2005 15:29:40 -0800
Message-ID: <7526e305050215152950f5a69e@mail.gmail.com>
Reply-To: Joe Scsi <joe.scsi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.193]:26559 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261945AbVBOX3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 18:29:43 -0500
Received: by wproxy.gmail.com with SMTP id 68so1027644wri
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 15:29:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

James, this looks like it would be really useful for my driver and
I hope it goes upstream soon.  I do have one question.

 > 2. rejig the scanning code to do target scanning via a parent generic
 > device rather than the HCTL numbers.

I see the internal changes to scsi_scan.c that this refers to, but
I'm not totally clear on what a driver should do to allocate a target
and scan it when it finds out about a new target port.

Thanks,
  Joe
