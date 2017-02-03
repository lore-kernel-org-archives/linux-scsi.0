From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V4 12/24] aacraid: Retrieve Queue Depth from Adapter FW
Date: Fri, 3 Feb 2017 10:14:34 +0100
Message-ID: <5edb61c4-7e4d-6335-0276-45edb6fc6ca1@suse.de>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170202235338.14724-13-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39659 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752158AbdBCJOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:14:37 -0500
In-Reply-To: <20170202235338.14724-13-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On 02/03/2017 12:53 AM, Raghava Aditya Renukunta wrote:
> Retrieved queue depth from fw and saved it for future use.
> Only applicable for HBA1000 drives.
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> ---
>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
