From: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 16/19] be2iscsi: Add support for iscsi boot
Date: Thu, 22 Jul 2010 13:37:56 -0400
Message-ID: <201007221337.57465.konrad@kernel.org>
References: <20100721225908.GA9784@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:53643 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0GWNKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2010 09:10:45 -0400
In-Reply-To: <20100721225908.GA9784@serverengines.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu


> +static ssize_t beiscsi_show_boot_eth_info(void *data, int type, char *buf)
> +{
> +	struct beiscsi_hba *phba = data;
> +	char *str = buf;
> +	int rc;
> +
> +	switch (type) {
> +	case ISCSI_BOOT_ETH_FLAGS:
> +			rc = sprintf(str, "2\n");
> +		break;
> +	case ISCSI_BOOT_ETH_INDEX:
> +			rc = sprintf(str, "0\n");

Offset by one extra tab.

Otherwise it looks ok to me.
