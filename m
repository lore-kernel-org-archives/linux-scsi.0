From: Brian King <brking@us.ibm.com>
Subject: Re: IBM Serveraid 4h on PSeries
Date: Mon, 06 Nov 2006 16:59:10 -0600
Message-ID: <454FBE3E.2020400@us.ibm.com>
References: <454EF015.7040206@christian.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49048 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1753905AbWKFW7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2006 17:59:19 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA6MxUts002730
	for <linux-scsi@vger.kernel.org>; Mon, 6 Nov 2006 17:59:30 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA6MxCVa279248
	for <linux-scsi@vger.kernel.org>; Mon, 6 Nov 2006 17:59:12 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA6MxBHA030630
	for <linux-scsi@vger.kernel.org>; Mon, 6 Nov 2006 17:59:11 -0500
In-Reply-To: <454EF015.7040206@christian.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ulrichenslin@christian.net
Cc: linux-scsi@vger.kernel.org, ipslinux@adaptec.com

Ulrich Enslin wrote:
> Hi
> 
> I hope you can help me, or give me clarity or pointers with my problem.
> 
> I have a IBM Pseries with a IBM Serveraid 4h card.  I have OpenSuse 10.1 
> installed,
> but it does not see the card.  In the PCI dump the card is listed, but 
> the IPS driver
> is missing.
> 
> I have seen from other posts that the IPS driver only comes with x86 
> linux distributions.

The last I knew, this driver didn't work on PPC64.

cc'ing the ips maintainer...


Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
