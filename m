From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: Re: No volumes detected by cciss driver
Date: Fri, 6 Feb 2004 17:07:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040207010758.29314.qmail@web10408.mail.yahoo.com>
References: <20040207005646.2433.qmail@web10406.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10408.mail.yahoo.com ([216.136.130.110]:11661 "HELO
	web10408.mail.yahoo.com") by vger.kernel.org with SMTP
	id S265657AbUBGBH7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 20:07:59 -0500
In-Reply-To: <20040207005646.2433.qmail@web10406.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> So, the real question is if anyone can help me figure why
> the SmartArray 6400 controller is not detected at all by
> the kernel, or if there is some minimum version of the 2.4
> kernel which I need to be running in order to use this
> controller. Looking at the Documentation/cciss.txt file in
> the kernel source for 2.4.21, it explicitly mentions the
> SmartArray 6400 as supported, but I don't have the 2.4.18
> source around anywhere to check that specific version.

And answering my own laziness: A few minutes on the lxr site
confirms that cciss.txt does not mention the SA 6400 in any
version of the kernel up through 2.4.20. So, presumably if
I can put together a 2.4.21 or later boot kernel, then the
system should work fine.

http://www.iglu.org.il/lxr/source/Documentation/cciss.txt?v=linux-2.4.18
http://www.iglu.org.il/lxr/source/Documentation/cciss.txt?v=linux-2.4.19
http://www.iglu.org.il/lxr/source/Documentation/cciss.txt


__________________________________
Do you Yahoo!?
Yahoo! Finance: Get your refund fast by filing online.
http://taxes.yahoo.com/filing.html
