From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Thu, 05 Oct 2006 15:11:41 -0700
Message-ID: <4525831D.60104@us.ibm.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com> <20061004132929.A29689@florence.linkmargin.com> <20061004205621.GF5091@rhun.haifa.ibm.com> <1159996277.3437.83.camel@mulgrave.il.steeleye.com> <20061005215504.GB14186@rhun.haifa.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:28356 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932315AbWJEWLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 18:11:44 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k95MBhk5023821
	for <linux-scsi@vger.kernel.org>; Thu, 5 Oct 2006 18:11:43 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k95MBhYZ127122
	for <linux-scsi@vger.kernel.org>; Thu, 5 Oct 2006 18:11:43 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k95MBhHj029342
	for <linux-scsi@vger.kernel.org>; Thu, 5 Oct 2006 18:11:43 -0400
In-Reply-To: <20061005215504.GB14186@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andy Warner <andyw@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>

Muli Ben-Yehuda wrote:

> Thanks. I was hoping to get to it today but ended up chasing a genirq
> bug in 2.6.19-rc1
> (http://marc.theaimsgroup.com/?l=linux-kernel&m=116008372309485&w=2)
> instead. I'll update when I'll know more. I saw some aic94xx patches
> going by - should I be doing the experiments on an aic94xx other than
> what's in mainline?

As far as I can tell, most of the patches that have gone by in the past
day or two have been to fix various expander problems... which your x366
doesn't have.  Though, it's possible that I've missed a patch or two.

--D
