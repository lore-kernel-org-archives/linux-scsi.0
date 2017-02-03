From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V4 08/24] aacraid: Added support for response path
Date: Fri, 3 Feb 2017 10:05:29 +0100
Message-ID: <7ba3c001-31c4-f495-bd0f-9b3228defa6a@suse.de>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170202235338.14724-9-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39065 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752315AbdBCJFc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:05:32 -0500
In-Reply-To: <20170202235338.14724-9-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com


On 02/03/2017 12:53 AM, Raghava Aditya Renukunta wrote:
> This patch enables the driver to actually process the I/O, or srb replies
> from adapter. In addition to any HBA1000 or SmartIOC2000 adapter events.
>
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> ---
>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
