From: "Dr. Ernst Molitor" <molitor@uni-bonn.de>
Subject: Re: Linux-2.6.0-test4: Kernel Panic in scsi_host_dev_release
Date: Tue, 26 Aug 2003 09:20:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061882454.491.4.camel@felicia>
References: <1061844849.486.12.camel@felicia>
	 <20030825234232.GA2470@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout06.sul.t-online.com ([194.25.134.19]:61589 "EHLO
	mailout06.sul.t-online.com") by vger.kernel.org with ESMTP
	id S262481AbTHZHVO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 03:21:14 -0400
In-Reply-To: <20030825234232.GA2470@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Dr. Ernst Molitor" <molitor@uni-bonn.de>

Dear Michael Anderson, 

thank you very much for your kind e-mail message and the patch you've
written. 

On Tue, 2003-08-26 at 01:42, Mike Anderson wrote:
> I believe the problem you are hitting is a bug in the code I added for a
> doing a put on the parent in the release function. If a driver calls
> scsi_register, but then has a problem in there detect where they need to
> call scsi_unregister the parent pointer of the struct device may never
> be set.
> 
> I you have time could you please try the patch below. I have compiled it
> only. I will try to run it with a modified driver that will fail in
> detect shortly.
> 

My pleasure. Your patch fixes the problem I have seen - thank you very
much! Linux-2.6.3-test4 is up and running on the box I'm writing this
message on.
 
> 
> We need to kfree the shost as the struct device is contained inside the
> scsi_host structure.

I see, thank you very much for your kind explanation.

Best wishes and regards, 

Ernst


