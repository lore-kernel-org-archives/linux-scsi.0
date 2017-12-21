From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: storvsc: Fix scsi_cmd error assignments in
 storvsc_handle_error
Date: Wed, 20 Dec 2017 21:24:10 -0500
Message-ID: <yq1fu84hl85.fsf@oracle.com>
References: <1513708368-25951-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513708368-25951-1-git-send-email-cavery@redhat.com> (Cathy
 Avery's message of "Tue, 19 Dec 2017 13:32:48 -0500")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: sthemmin@microsoft.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, jejb@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org


Cathy,

> When an I/O is returned with an srb_status of SRB_STATUS_INVALID_LUN
> which has zero good_bytes it must be assigned an error. Otherwise the
> I/O will be continuously requeued and will cause a deadlock in the
> case where disks are being hot added and removed. sd_probe_async will
> wait forever for its I/O to complete while holding
> scsi_sd_probe_domain.
>
> Also returning the default error of DID_TARGET_FAILURE causes
> multipath to not retry the I/O resulting in applications receiving I/O
> errors before a failover can occur.

Applied to 4.15/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
