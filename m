From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: remove redundant null check on eqe
Date: Thu, 14 Sep 2017 07:47:59 -0700
Message-ID: <9d36fb68-7997-cba7-8e27-5b28306e443c@broadcom.com>
References: <20170908080201.9592-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170908080201.9592-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/8/2017 1:02 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The pointer eqe is always non-null inside the while loop, so the
> check to see if eqe is NULL is redudant and hence can be removed.
>
> Detected by CoverityScan CID#1248693 ("Logically Dead Code")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>

Yep. thank you

Signed-off-by: James Smart <james.smart@broadcom.com>
