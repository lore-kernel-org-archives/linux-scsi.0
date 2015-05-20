From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v1 1/3] phy: qcom-ufs: fix build error when the driver
 is built as a module
Date: Wed, 20 May 2015 10:14:38 +0200
Message-ID: <1432109678.21715.40.camel@x220>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
	 <1432043231-31102-2-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:55879 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbbETIOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2015 04:14:43 -0400
In-Reply-To: <1432043231-31102-2-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org

On Tue, 2015-05-19 at 16:47 +0300, Yaniv Gardi wrote:
> Export the following functions in order to avoid build errors
> when the driver is compiled as a module:

Where "the driver" actually means something like ufs-qcom.c, or
SCSI_UFS_QCOM, or "QCOM specific hooks to UFS controller platform
driver", right?

> ERROR: "ufs_qcom_phy_disable_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_is_pcs_ready" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_disable_iface_clk" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_start_serdes" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_calibrate_phy" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_dev_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_set_tx_lane_enable" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_disable_dev_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_save_controller_version" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> ERROR: "ufs_qcom_phy_enable_iface_clk" [drivers/scsi/ufs/ufs-qcom.ko] undefined!
> make[1]: *** [__modpost] Error 1

Thanks,


Paul Bolle

