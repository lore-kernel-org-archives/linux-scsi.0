From: Santiago Leon <santil@us.ibm.com>
Subject: Re: [PATCH 8/8] scsi tgt: IBM eServer i/pSeries virtual SCSI target
 driver
Date: Thu, 30 Nov 2006 09:38:35 -0600
Message-ID: <456EFAFB.4050206@us.ibm.com>
References: <20061116192426Y.fujita.tomonori@lab.ntt.co.jp> <20061128233117S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60371 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030560AbWK3PhK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Nov 2006 10:37:10 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAUFb800032483
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2006 10:37:08 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAUFb8Mj218350
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2006 10:37:08 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAUFb7Ih002444
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2006 10:37:08 -0500
In-Reply-To: <20061128233117S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: boutcher@cs.umn.edu, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> Hi ibmvscsi team,
> 
> Can I get your ACK on this patch to get it merged into the scsi-misc?

No problem, Ive been playing with it for a while now.  Just one tiny 
thing, Dave Boutcher has changed jobs within IBM, so please put me in 
the MODULE_AUTHOR() call.

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH 8/8] scsi tgt: IBM eServer i/pSeries virtual SCSI target driver
> Date: Thu, 16 Nov 2006 19:24:26 +0900
> 
>> This is IBM Virtual SCSI target driver for tgt. The driver is based on
>> the original ibmvscsis driver:
>>
>> http://lkml.org/lkml/2005/10/17/99
>>
>>
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

Signed-off-by: Santiago Leon <santil@us.ibm.com>

-- 
Santiago A. Leon
Power Linux Development
IBM Linux Technology Center
