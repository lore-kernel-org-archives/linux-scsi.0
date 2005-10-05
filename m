From: "'Christoph Hellwig'" <hch@lst.de>
Subject: Re: [PATCH] megaraid_sas: fix compat ioctl handling
Date: Wed, 5 Oct 2005 18:25:40 +0200
Message-ID: <20051005162540.GA3930@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD21B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:1468 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1030215AbVJEQZq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 12:25:46 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD21B@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: 'Christoph Hellwig' <hch@lst.de>, linux-scsi@vger.kernel.org

> MEGASAS_IOC_FIRMWARE32 which is defined outside CONFIG_COMPAT is using
> struct compat_megasas_iocpacket which is inside the CONFIG_COMPAT. It
> still works because MEGASAS_IOC_FIRMWARE32 is not referenced elsewhere
> in the code. I wasn't sure if you inteneded this to be like this (to 
> force driver not to use FIRMWARE32 value in outside CONFIG_COMPAT).

as you said it shouldn't matter.  if you prefer it inside the ifdef
I can send an incremental patch to fix it up.
