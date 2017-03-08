From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] storvsc: workaround for virtual DVD SCSI version
Date: Tue, 07 Mar 2017 20:21:44 -0500
Message-ID: <yq1lgsgimvr.fsf@oracle.com>
References: <20170307171553.13247-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170307171553.13247-1-sthemmin@microsoft.com> (Stephen
 Hemminger's message of "Tue, 7 Mar 2017 09:15:53 -0800")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, hch@lst.de, hare@suse.de, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Stephen" == Stephen Hemminger <stephen@networkplumber.org> writes:

Stephen,

Stephen> Hyper-V host emulation of SCSI for virtual DVD device reports
Stephen> SCSI version 0 (UNKNOWN) but is still capable of supporting
Stephen> REPORTLUN.

Stephen> Without this patch, a GEN2 Linux guest on Hyper-V will not boot
Stephen> 4.11 successfully with virtual DVD ROM device. What happens is
Stephen> that the SCSI scan process falls back to doing sequential
Stephen> probing by INQUIRY.  But the storvsc driver has a previous
Stephen> workaround that masks/blocks all errors reports from INQUIRY
Stephen> (or MODE_SENSE) commands.  This workaround causes the scan to
Stephen> then populate a full set of bogus LUN's on the target and then
Stephen> sends kernel spinning off into a death spiral doing block reads
Stephen> on the non-existent LUNs.

Stephen> By setting the correct blacklist flags, the target with the DVD
Stephen> device is scanned with REPORTLUN and that works correctly.

Applied to 4.11/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
