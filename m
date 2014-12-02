From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch v2] scsi: set fmt to NULL scsi_extd_sense_format() by
 default
Date: Tue, 02 Dec 2014 06:50:48 -0800
Message-ID: <1417531848.2424.0.camel@HansenPartnership.com>
References: <20141202110729.GA17562@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20141202110729.GA17562@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-12-02 at 14:07 +0300, Dan Carpenter wrote:
> One of the two callers passes an unintialized pointer as "fmt" and
> expects it to be set to NULL if there is no format string.  Let's make
> this function work as expected.
> 
> Fixes: d811b848ebb7 ('scsi: use sdev as argument for sense code printing')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2:  Change scsi_extd_sense_format() instead of the caller

Reviewed-by: James Bottomley <JBottomley@Parallels.com>

James


