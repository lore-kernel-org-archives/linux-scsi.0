From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: 64-bit SCSI LUN addressing on Linux
Date: Thu, 30 Jun 2005 12:59:04 -0700
Message-ID: <OFCDE92F9C.00594201-ON88257030.006C2A9E-88257030.006DB9BE@us.ibm.com>
References: <20050630170634.GA31249@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:28631 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263095AbVF3T7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 15:59:08 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5UJx7lM021175
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2005 15:59:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5UJx7lF239032
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2005 15:59:07 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5UJx6fP029508
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2005 15:59:07 -0400
In-Reply-To: <20050630170634.GA31249@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, "Martin W. Schlining III" <mschlining@datadirectnet.com>

>Yeah, people tend to say LUNs when they mean storage devices a lot,
>so I've started to look over the slight misuses if things make sense
>otherwise.

We all have to do that, because the vast majority of people who are not 
storage engineers, and a disturbing portion of people who are, mean LU (or 
storage device) when they say LUN.  But we shouldn't compound the problem 
by not pointing out the mistakes; people deserve to know there's a clearer 
way to say what they're trying to say.  In many contexts, I have been 
genuinely confused as to whether a person was talking about a LUN or  a 
LU.  "LUN discovery," for example is a much simpler problem than the more 
general problem of LU (or volume or device) discovery.  I end up having to 
do a meta-analysis of which language the author is most likely to be 
speaking.  In the current discussion, we have the phrase "64-bit SCSI LUN 
addressing," which does sound a whole lot like it's about 64 bit LUNs. 
Only when you look closely do you see that decoded the other way, it makes 
more sense.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

