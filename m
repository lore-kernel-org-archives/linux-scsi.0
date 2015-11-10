From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 00/32] HiSilicon SAS driver
Date: Tue, 10 Nov 2015 08:15:37 +0100
Message-ID: <56419999.3020809@suse.de>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, xuwei5@hisilicon.com, zhangfei.gao@linaro.org
List-Id: linux-scsi@vger.kernel.org

On 11/09/2015 05:32 PM, John Garry wrote:
> This is the driver patchset for the HiSilicon SAS driver. The driver
> is a platform driver.
>=20
> The driver will support multiple revisions of HW. Currently only "v1"
> HW is supported.
>=20
> The driver uses libsas framework within the SCSI framework.
>=20
> The v1 HW supports SSP and SMP, but not STP/SATA.
>=20
> Differences to v2:
> - update device tree bindings
> - remove while loops when evaluating hba struct
> - remove _lo and _hi DMA struct fields
> - revised spinlock usage
> - fix error handling for when CMPLT_HDR_ERR_RCRD_XFRD set
> - general coding style and cosmetic fixes
>=20
> Differences to v1:
> - re-arch driver into main module and hw-specific driver module
> - allocate hisi_hba in scsi_host_alloc
> - use of_irq_count get irq count - depends on [1]
> - use syscon to handle ctrl reg access
> - get SAS address from device tree
> - do not set cmd_per_lun to 1
> - remove remove controller id
> - use static wq in phy struct
> - process control phy in caller context
> - fix port->port_attached issue for rmmod
>=20
> [1] http://www.spinics.net/lists/arm-kernel/msg452833.html
>=20
Nice work.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Although it should be dead trivial to convert the driver to
use scsi-mq; but that can come in with a later patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
