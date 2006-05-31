From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch 2/2] megaraid_sas: add support for ZCR controller
Date: Tue, 30 May 2006 17:53:10 -0700
Message-ID: <20060530175310.ce49a826.akpm@osdl.org>
References: <1149018114.8277.37.camel@dhcp80-125.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15583 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932545AbWEaAs7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 20:48:59 -0400
In-Reply-To: <1149018114.8277.37.camel@dhcp80-125.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, knsyam@lsil.com, boy@lsil.com, hch@lst.de, sreenib@lsil.com, sumantp@lsil.com

On Tue, 30 May 2006 12:41:54 -0700
Sumant Patro <sumantp@lsil.com> wrote:

> 	 PCI_VENDOR_ID_LSI_LOGIC,
> -	 PCI_DEVICE_ID_LSI_SAS1078R, // ppc IOP
> +	 PCI_DEVICE_ID_LSI_SAS1078R, /* ppc IOP */
>  	 PCI_ANY_ID,
>  	 PCI_ANY_ID,
>  	},
> +	 PCI_VENDOR_ID_LSI_LOGIC,
> +	 PCI_DEVICE_ID_LSI_VERDE_ZCR,	/* xscale IOP, vega */
> +	 PCI_ANY_ID,
> +	 PCI_ANY_ID,
> +	 },

This doesn't have a hope of compiling, which makes one wonder about its
testing status.


