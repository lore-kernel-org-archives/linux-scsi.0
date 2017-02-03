From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V4 16/24] aacraid: Add task management functionality
Date: Fri, 3 Feb 2017 10:22:03 +0100
Message-ID: <003827f9-cc37-5ec2-f1d9-da72a4a4f9cc@suse.de>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170202235338.14724-17-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40237 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbdBCJWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:22:05 -0500
In-Reply-To: <20170202235338.14724-17-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On 02/03/2017 12:53 AM, Raghava Aditya Renukunta wrote:
> Added support to send out task management commands.
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> ---
[...]
> Zapped C++ comment
[...]
> +static int aac_adapter_hba(struct fib *fib, struct scsi_cmnd *cmd)
> +{
> +	struct aac_hba_cmd_req *hbacmd = aac_construct_hbacmd(fib, cmd);
> +	struct aac_dev *dev;
> +	// u16 fibsize;

Here you missed one ;-)
Anyways,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
