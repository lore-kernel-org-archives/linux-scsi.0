From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: max GiB written per boot
Date: 10 Oct 2003 14:54:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065819281.7434.26.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2>
	 <1065474044.6835.44.camel@patehci2> <1065484077.2899.1.camel@patehci2>
	 <20031007055714.GO972@suse.de>  <20031007151225.0a65dcb7.rddunlap@osdl.org>
	 <1065736761.2288.33.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:56038 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262062AbTJJUyz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 16:54:55 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 1E5F51E07
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2003 14:54:55 -0600 (MDT)
In-Reply-To: <1065736761.2288.33.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> > > ...
> >
> > ... always ... an oops ... Must be fixed.
>
> Here's another ...

I remember now where I got the idea people don't want to hear about how
easily I can provoke "kernel NULL pointer dereference":

http://www.tux.org/lkml/#s4-3
includes such not-completely-true claims as:

"(REG) Don't even bother posting an Oops if you haven't run it through
ksymoops to decode the symbol addresses. The report will be ignored
because it contains too little useful information."

That was the convention I was trying to follow before I was told
differently.

Pat LaVarre.



