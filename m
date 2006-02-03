From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/2] megaraid_sas: support for 1078 type controller
	added
Date: Fri, 03 Feb 2006 17:54:49 -0600
Message-ID: <1139010889.9267.14.camel@localhost.localdomain>
References: <1139009675.602.15.camel@dhcp80-31.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16571 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030249AbWBCXzC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 18:55:02 -0500
In-Reply-To: <1139009675.602.15.camel@dhcp80-31.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, Sumant Patro <sumantp@lsil.com>
Cc: hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sreenib@lsil.com, Neela.kolli@lsil.com, Bo.Yang@lsil.com, hdoelfel@lsil.com

On Fri, 2006-02-03 at 15:34 -0800, Sumant Patro wrote:
>         {
> +        PCI_VENDOR_ID_LSI_LOGIC,
> +        PCI_DEVICE_ID_LSI_SAS1078R, // ppc IOP
> +        PCI_ANY_ID,
> +        PCI_ANY_ID,
> +       },

I thought the fusion people objected to this because they also have a
fusion card with this id; has that now been resolved?

James


