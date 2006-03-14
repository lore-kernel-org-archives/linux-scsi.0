From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH ] drivers/scsi/scsi.c - export reprobe
Date: Tue, 14 Mar 2006 09:58:06 +0100
Message-ID: <1142326687.3027.20.camel@laptopd505.fenrus.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D82A@NAMAIL2.ad.lsil.com>
Reply-To: arjan@infradead.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54918 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751021AbWCNI6P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 03:58:15 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F36D82A@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: gregkh@novell.com, hch@lst.de, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, 2006-03-13 at 17:52 -0700, Moore, Eric wrote:
> Request for exporting device_reprobe - 
> This is scsi wrapper portion.
> 
> ---------------------------------------------------
> Adding support for exposing hidden raid components 
> for sg interface. The sdev->no_uld_attach flag
> will set set accordingly.
> 
> The sas module supports adding/removing raid
> volumes using online storage management application
> interface.  


I'd say this export wants to be _GPL as well; it's a most trivial
wrapper around a _GPL export after all, and new functionality


