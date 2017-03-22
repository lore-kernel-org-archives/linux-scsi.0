From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] scsi: fcoe: sanity check string size for store_ctrl_mode
 option
Date: Wed, 22 Mar 2017 19:42:08 +0000
Message-ID: <1b8384a7-9efe-7b93-e418-0f377bb84a73@canonical.com>
References: <20170322140137.28485-1-colin.king@canonical.com>
 <20170322193945.GK32449@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48456 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759670AbdCVTmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2017 15:42:12 -0400
In-Reply-To: <20170322193945.GK32449@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 22/03/17 19:39, Dan Carpenter wrote:
> On Wed, Mar 22, 2017 at 02:01:37PM +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Reading and writing to mode[count - 1] implies the count should not
>> be less than 1 so add a sanity check for this.
>>
>> Detected with CoverityScan, CID#1357345 ("Overflowed array index write")
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> This is harmless, of course, but count can't be zero.  This is a sysfs
> file so we test for zero size writes in sysfs_kf_write() and return
> early.

Ah, thanks for pointing out that. I overlooked that detail.

Colin

> 
> regards,
> dan carpenter
> 
