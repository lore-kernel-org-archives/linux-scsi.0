From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 1/3] phy: qcom-ufs: fix build error when the driver is
 built as a module
Date: Wed, 20 May 2015 09:40:24 -0000
Message-ID: <b2b0ec2372bc6fe150b58a535237509c.squirrel@www.codeaurora.org>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
    <1432043231-31102-2-git-send-email-ygardi@codeaurora.org>
    <1432109678.21715.40.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432109678.21715.40.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

> On Tue, 2015-05-19 at 16:47 +0300, Yaniv Gardi wrote:
>> Export the following functions in order to avoid build errors
>> when the driver is compiled as a module:
>
> Where "the driver" actually means something like ufs-qcom.c, or
> SCSI_UFS_QCOM, or "QCOM specific hooks to UFS controller platform
> driver", right?
>

yes, Paul, you are correct.

>> ERROR: "ufs_qcom_phy_disable_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_enable_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_is_pcs_ready" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_disable_iface_clk" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_start_serdes" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_calibrate_phy" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_enable_dev_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_set_tx_lane_enable" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_disable_dev_ref_clk" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> ERROR: "ufs_qcom_phy_save_controller_version"
>> [drivers/scsi/ufs/ufs-qcom.ko] undefined!
>> ERROR: "ufs_qcom_phy_enable_iface_clk" [drivers/scsi/ufs/ufs-qcom.ko]
>> undefined!
>> make[1]: *** [__modpost] Error 1
>
> Thanks,
>
>
> Paul Bolle
>
>
