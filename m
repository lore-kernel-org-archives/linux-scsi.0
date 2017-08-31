From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] storvsc: fix memory leak on ring buffer busy
Date: Wed, 30 Aug 2017 21:55:10 -0400
Message-ID: <yq1y3q0y001.fsf@oracle.com>
References: <20170829004359.28526-1-longli@exchange.microsoft.com>
 <yq18ti1265c.fsf@oracle.com>
 <MWHPR21MB0190F8C50CCF7CFA0EDCA7A6CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <MWHPR21MB0190F8C50CCF7CFA0EDCA7A6CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
 (Long Li's message of "Wed, 30 Aug 2017 03:48:54 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org


Long,

>> Which kernel version is this patch aimed at?
>
> Martin, thanks for pointing this out. This should also go to stable
> trees.

The reason I asked is that it didn't apply to neither fixes, nor
for-next.

I applied it to 4.13/scsi-fixes by hand and added a stable tag.

-- 
Martin K. Petersen	Oracle Linux Engineering
