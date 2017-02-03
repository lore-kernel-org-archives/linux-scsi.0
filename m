From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V4 18/24] aacraid: VPD 83 type3 support
Date: Fri, 3 Feb 2017 10:23:48 +0100
Message-ID: <34009fba-c5fb-924d-b06f-d6f184ae03f6@suse.de>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170202235338.14724-19-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752232AbdBCJXu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:23:50 -0500
In-Reply-To: <20170202235338.14724-19-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On 02/03/2017 12:53 AM, Raghava Aditya Renukunta wrote:
> This patch adds support to retrieve the unique identifier data (VPD page
> 83 type3) for Logical drives created on SmartIOC 2000 products. In
> addition  added a sysfs device structure to expose the id information.
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> ---
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
