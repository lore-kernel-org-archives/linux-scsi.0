From: Joe Scsi <joe.scsi@gmail.com>
Subject: Re: LUN discovery by SCSI midlayer?
Date: Tue, 15 Feb 2005 08:58:14 -0800
Message-ID: <7526e3050502150858104f99eb@mail.gmail.com>
References: <7526e30505021420354e6a1707@mail.gmail.com>
	 <20050215140642.GA2431@lists.us.dell.com>
Reply-To: Joe Scsi <joe.scsi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.202]:8847 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261794AbVBOQ6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 11:58:18 -0500
Received: by wproxy.gmail.com with SMTP id 68so957230wri
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 08:58:14 -0800 (PST)
In-Reply-To: <20050215140642.GA2431@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org

> Can you take a look at the patches I posted last week and see if that
> would work for you?

Hmm, I'm not sure.  The issue I have is that I know when target ports
appear and disappear, and I'd like to use some general SCSI midlayer
stuff to discover what LUNs are behind a target port.  So if I have to
know the full HCTL then that doesn't really help me.

It seems kind of ugly if I have to do the REPORT_LUNs command
myself and manually call scsi_add_device() for each LUN.

(Disappearing target ports seem easier to handle, because I can keep
a list of LUNs per target port and call scsi_remove_device() on each LUN)

Thanks,
  Joe
