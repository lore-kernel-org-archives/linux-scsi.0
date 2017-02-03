From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V4 11/24] aacraid: Added support for periodic wellness
 sync
Date: Fri, 3 Feb 2017 10:12:38 +0100
Message-ID: <324befbc-0564-8295-75bc-761ce6cc0d0f@suse.de>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170202235338.14724-12-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdBCJMk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:12:40 -0500
In-Reply-To: <20170202235338.14724-12-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On 02/03/2017 12:53 AM, Raghava Aditya Renukunta wrote:
> This patch adds a new functions that periodically sync the time of host
> to the adapter. In addition also informs the adapter that the driver is
> alive and kicking. Only applicable to the HBA1000 and SMARTIOC2000.
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> ---
>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
