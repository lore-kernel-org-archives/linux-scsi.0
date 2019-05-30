From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Use *_pool_zalloc rather than *_pool_alloc
Date: Wed, 29 May 2019 17:23:40 -0700
Message-ID: <8e9198f2-1247-f7bc-7856-721664b64316@broadcom.com>
References: <1559161113889-196429735-0-diffsplit-thomas@m3y3r.de>
 <1559161113901-1017843021-1-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559161113901-1017843021-1-diffsplit-thomas@m3y3r.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 5/29/2019 1:21 PM, Thomas Meyer wrote:
> Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>
>

looks good

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james
