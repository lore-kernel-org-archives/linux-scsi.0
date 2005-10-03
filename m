From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsi: scsi inquiry timeout config option
Date: Mon, 03 Oct 2005 15:44:28 -0500
Message-ID: <4341982C.8070702@us.ibm.com>
References: <200510032026.j93KQViR015934@d01av04.pok.ibm.com> <20051003203924.GS29826@austin.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:65236 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S932433AbVJCUoe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2005 16:44:34 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id j93Kft1m008196
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 16:41:55 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j93KjFQm538698
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 14:45:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j93KiWPg028554
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 14:44:33 -0600
In-Reply-To: <20051003203924.GS29826@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linas <linas@austin.ibm.com>
Cc: James.Bottomley@steeleye.com, linuxppc64-dev@ozlabs.org, linux-scsi@vger.kernel.org

linas wrote:
> On Mon, Oct 03, 2005 at 03:26:30PM -0500, brking@us.ibm.com was heard to remark:
> 
>>Add a .config option to default the scsi scan inquiry timeout.
>>Due to a broken device (SCSI/ATA converter card) that is very
>>common on IBM iSeries/pSeries machines, these architectures
>>need a longer default inquiry timeout.
> 
> 
> Hmm, I thought I fixed this several yeas ago. I guess it didn't 
> stay fixed? 

Some distro kernels have the default inquiry timeout changed for ppc64, but
mainline only has the module parameter.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
