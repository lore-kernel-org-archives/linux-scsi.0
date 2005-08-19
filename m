From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 16:54:16 -0400
Message-ID: <430646F8.7050607@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>	 <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de>	 <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de>	 <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org>	 <43061FC9.8060301@adaptec.com> <1124481582.5130.88.camel@mulgrave> <430641CF.3070709@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:24542 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932293AbVHSUyn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 16:54:43 -0400
In-Reply-To: <430641CF.3070709@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <jejb@steeleye.com>, Christoph Hellwig <hch@infradead.org>, James.Smart@Emulex.Com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> James, the "current SAS class" _will_go_ into the kernel because:
> 	- It is 3 vendor driven: LSI, Dell, HP.
> 	- It is being developed by you and Christoph, the people
> who decide what goes in or not.

No, not for these reasons.

It will go in because it is small, and can be improved over time as 
vendors such as Adaptec teach us the proper topology.

It is a standard problem:  engineers know their hardware, and know the 
specs, but not the Linux development process.

An Adaptec SAS driver can be in the 2.6.14 kernel, if it is small.

The process then starts:
1) Luben points out a problem.
2) The best solution is discussed.
3) A patch is created to solve that one problem.
4) Go to step #1.

We grow SAS support, like growing a plant or tree.  Start with a seed, 
not a full-grown tree.

	Jeff


