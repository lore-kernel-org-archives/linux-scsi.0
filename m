From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 3/6] scsi: lpfc: Cocci spatch "pool_zalloc-simple"
Date: Fri, 22 Sep 2017 08:27:50 -0700
Message-ID: <f917c9c8-9f89-fe75-5c5f-1ecb29c6e7a9@broadcom.com>
References: <1505974468535-2047238743-0-diffsplit-thomas@m3y3r.de>
 <1505974468535-735692655-3-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505974468535-735692655-3-diffsplit-thomas@m3y3r.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/20/2017 11:15 PM, Thomas Meyer wrote:
> Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.
> Found by coccinelle spatch "api/alloc/pool_zalloc-simple.cocci"
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>
>

Looks good. Thanks.

Signed-off-by: James Smart <james.smart@broadcom.com>
