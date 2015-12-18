From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] hpsa: change SAS transport devices to bus 0.
Date: Fri, 18 Dec 2015 14:14:57 -0600
Message-ID: <75B64E34-4046-437C-9BE5-93CAF370DB08@linux.vnet.ibm.com>
References: <20151209211816.519.50876.stgit@brunhilda> <20151209211850.519.87076.stgit@brunhilda> <C8F529F3-D668-473E-92D5-5261A147B9E5@linux.vnet.ibm.com> <56703105.9050109@pmcs.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:57460 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736AbbLRUPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 15:15:10 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 18 Dec 2015 15:15:10 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 98CE538C8051
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 15:02:24 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBIKF6ra15138844
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 20:15:06 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBIKBmjr009750
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 15:11:53 -0500
In-Reply-To: <56703105.9050109@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>
Cc: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com, linux-scsi@vger.kernel.org

> On Dec 15, 2015, at 9:25 AM, Don Brace <brace77070@gmail.com> wrote:
> 
> On 12/09/2015 05:21 PM, Matthew R. Ochs wrote:
>>> On Dec 9, 2015, at 3:18 PM, Don Brace <don.brace@pmcs.com> wrote:
>>> 
>>> sas transport places devices on bus 0 but driver was setting
>>> the bus to 3.
>>> 
>>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>>> ---
>>> drivers/scsi/hpsa.h |    2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
>>> index ae5beda..fdd39fc 100644
>>> --- a/drivers/scsi/hpsa.h
>>> +++ b/drivers/scsi/hpsa.h
>>> @@ -400,7 +400,7 @@ struct offline_device_entry {
>>> #define HPSA_PHYSICAL_DEVICE_BUS	0
>>> #define HPSA_RAID_VOLUME_BUS		1
>>> #define HPSA_EXTERNAL_RAID_VOLUME_BUS	2
>>> -#define HPSA_HBA_BUS			3
>>> +#define HPSA_HBA_BUS			0
>> Is this not the same as using HPSA_PHYSICAL_DEVICE_BUS?
> I was just trying to minimize the changes. I can update the driver
> is necessary.

Understandable.

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

