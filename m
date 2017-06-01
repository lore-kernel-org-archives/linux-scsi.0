From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] scsi: lpfc: fix spelling mistake "entrys" -> "entries"
Date: Thu, 1 Jun 2017 15:40:25 +0100
Message-ID: <b5f2ac31-d1cf-7f29-e0cd-0b8f8954ad9a@canonical.com>
References: <20170526101137.14282-1-colin.king@canonical.com>
 <20170601143519.mk4tvxwcl63y3zwm@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170601143519.mk4tvxwcl63y3zwm@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/06/17 15:35, Dan Carpenter wrote:
> On Fri, May 26, 2017 at 11:11:37AM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Trivial fix to spelling mistake in debugfs message
>>
> 
> Are you using a tool to find all these spelling mistakes?

Yep, I'm using kernelscan [1]

kernelscan -c path-to-kernel-source

I run this daily and diff the latest with the previous results. It uses
the dictionary from "spell". It's been hand optimized to be rather fast.

[1] https://github.com/ColinIanKing/kernelscan

> 
> regards,
> dan carpenter
> 
