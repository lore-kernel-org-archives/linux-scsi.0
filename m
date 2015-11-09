From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 11/32] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Mon, 09 Nov 2015 17:28:46 +0100
Message-ID: <4369607.QVA3rBnZUm@wuerfel>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com> <1447086757-147706-12-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:64630 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbbKIQ32 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 11:29:28 -0500
In-Reply-To: <1447086757-147706-12-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org

On Tuesday 10 November 2015 00:32:16 John Garry wrote:
>  }
>  
> +static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
> +{
> +       int i;
> +
> +       for (i = 0; i < hisi_hba->n_phy; i++)
> +               memcpy(&hisi_hba->phy[i].dev_sas_addr,
> +                      hisi_hba->sas_addr,
> +                      SAS_ADDR_SIZE);
> +}

I don't know the background here, but I thought it would have to
be a different address on each phy. Are you sure this is not the
case?

	Arnd
