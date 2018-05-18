From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Avoid allocating memory for temp
 cpumasks
Date: Fri, 18 May 2018 11:24:41 -0400
Message-ID: <yq17eo1gf5y.fsf@oracle.com>
References: <1526591260-27162-1-git-send-email-mikelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1526591260-27162-1-git-send-email-mikelley@microsoft.com>
 (Michael Kelley's message of "Thu, 17 May 2018 14:07:40 -0700")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Michael Kelley <mhkelley58@gmail.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, mikelley@microsoft.com, devel@linuxdriverproject.org, sthemmin@microsoft.com
List-Id: linux-scsi@vger.kernel.org


Michael,

> Current code allocates 240 Kbytes (in typical configs) for each
> synthetic SCSI controller to use as temp cpumask variables.  Recode to
> avoid needing the temp cpumask variables and remove the memory
> allocation.

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
