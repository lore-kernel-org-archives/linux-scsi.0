From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/7] - MPT FUSION - SPLITTING SCSI HOST DRIVERS
Date: Fri, 25 Mar 2005 21:32:03 -0600
Message-ID: <1111807923.5541.3.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C01B70560@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:8108 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261921AbVCZDcM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 22:32:12 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C01B70560@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, 2005-03-24 at 16:56 -0700, Moore, Eric Dean wrote:
> +
>  config FUSION_FC
> -       tristate "Fusion MPT (base + ScsiHost) drivers for FC"
> -       depends on PCI && SCSI
> +       tristate "Fusion MPT (ScsiHost) drivers for FC"

This rejects completely in Kconfig.  Could you check your base for the
diffs ... there's no FUSION_FC parameter in the vanilla kernel.

Thanks,

James


