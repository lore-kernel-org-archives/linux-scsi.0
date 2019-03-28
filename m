From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libcxgbi: remove uninitialized variable len
Date: Wed, 27 Mar 2019 20:59:55 -0400
Message-ID: <yq15zs3x184.fsf@oracle.com>
References: <20190316225709.8630-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190316225709.8630-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 16 Mar 2019 22:57:09 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, David Ahern <dsahern@gmail.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Colin,

> The variable len is not being inintialized and the uninitialized value
> is being returned. However, this return path is never reached because
> the default case in the switch statement returns -ENOSYS.  Clean up
> the code by replacing the return -ENOSYS with a break for the default
> case and returning -ENOSYS at the end of the function.  This allows
> len to be removed.

Not a fan of this ENOSYS business but I guess it's been that way
forever. Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
