From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V4 10/24] aacraid: Reworked aac_command_thread
Date: Fri, 3 Feb 2017 10:09:36 +0100
Message-ID: <ee2a7bc3-60a9-7820-68ae-2922adf424c7@suse.de>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170202235338.14724-11-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39319 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdBCJJj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:09:39 -0500
In-Reply-To: <20170202235338.14724-11-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com


On 02/03/2017 12:53 AM, Raghava Aditya Renukunta wrote:
> Reworked aac_command_thread into aac_process_events
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> ---
>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
