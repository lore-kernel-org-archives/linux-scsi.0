From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: fcoe: sanity check string size for store_ctrl_mode
 option
Date: Wed, 22 Mar 2017 22:39:45 +0300
Message-ID: <20170322193945.GK32449@mwanda>
References: <20170322140137.28485-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170322140137.28485-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 22, 2017 at 02:01:37PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Reading and writing to mode[count - 1] implies the count should not
> be less than 1 so add a sanity check for this.
> 
> Detected with CoverityScan, CID#1357345 ("Overflowed array index write")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

This is harmless, of course, but count can't be zero.  This is a sysfs
file so we test for zero size writes in sysfs_kf_write() and return
early.

regards,
dan carpenter

