From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Fri, 07 Nov 2003 09:11:46 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FAAD532.2060300@torque.net>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org> <1067531731.4250.11.camel@pathost1.iomegacorp.com> <20031030091808.A6781@beaverton.ibm.com> <1067535485.6411.42.camel@pathost1.iomegacorp.com> <20031030100501.A7250@beaverton.ibm.com> <1067541899.1141.4.camel@ronald.kuetemeier.com> <20031030134850.A9076@beaverton.ibm.com> <1067551081.1138.7.camel@ronald.kuetemeier.com> <1067558384.14409.50.camel@patrh9> <20031031101645.A14729@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:16651 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263960AbTKGJRU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 04:17:20 -0500
In-Reply-To: <20031031101645.A14729@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, ronald@kuetemeier.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

Patrick Mansfield wrote:
> On Thu, Oct 30, 2003 at 04:59:45PM -0700, Pat LaVarre wrote:
> 
>>Can we cycle more quickly thru compile-test-edit up in user land, rather
>>than patching the kernel?
> 
> 
> Good idea.
> 
> 
>>sudo ./plscsi /dev/sg1 -v -i x1C -x "5A 00 08:00:00:00 00 00:1C 00"
>>sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 3F:00:00:00 00 00:04 00"
>>sudo ./plscsi /dev/sg1 -v -i 4   -x "5A 00 00:00:00:00 00 00:04 00"
>>sudo ./plscsi /dev/sg1 -v -i xFF -x "5A 00 3F:00:00:00 00 00:FF 00"

Patrick + Pat,
plscsi is starting to look remarkably like FreeBSD's
camcontrol utility. Perhaps we should be looking at
implementing camcontrol in Linux.

> Nice. Does sg_utils have an equivalent tool?
> 
> You can use /dev/sdN with 2.6.
> 
> 
>>Also personally I find the source for that plscsi app impenetrably awful
>>to read.
> 
> 
> Maybe you can rewrite it in c and get it into sg_utils.

I have no objection to putting utilities written in
C++ in sg3_utils.

Doug Gilbert


