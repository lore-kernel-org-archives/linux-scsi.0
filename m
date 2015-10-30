From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 1/8] phy: qcom-ufs: fix build error when the component
 is built as a module
Date: Fri, 30 Oct 2015 09:25:00 +0100
Message-ID: <5633295C.7030800@suse.de>
References: <1446030951-2431-1-git-send-email-ygardi@codeaurora.org>
 <1446030951-2431-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446030951-2431-2-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Kishon Vijay Abraham I <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

On 10/28/2015 12:15 PM, Yaniv Gardi wrote:
> Export the following functions in order to avoid build errors
> when the component PHY_QCOM_UFS is compiled as a module:
>=20
> ERROR: "ufs_qcom_phy_disable_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_is_pcs_ready"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_disable_iface_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_start_serdes"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_calibrate_phy"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_dev_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_set_tx_lane_enable"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_disable_dev_ref_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_save_controller_version"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_iface_clk"
> 	[drivers/scsi/ufs/ufs-qcom.ko] undefined!
> make[1]: *** [__modpost] Error 1
>=20
> Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>=20
> ---
>  drivers/phy/phy-qcom-ufs.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
