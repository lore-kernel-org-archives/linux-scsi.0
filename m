From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: aic79xx update?
Date: Tue, 24 May 2005 14:54:28 -0400
Message-ID: <42937864.8030204@adaptec.com>
References: <42932AAD.9060609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28309 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261389AbVEXSyd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 14:54:33 -0400
In-Reply-To: <42932AAD.9060609@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 05/24/05 09:22, Hannes Reinecke wrote:
> Hi Luben,
> 
> I did some patch regarding 'rmmod aic79xx' which got partially vetoed as
> the aic79xx driver should rather be updated to use the spi_transport
> class as the aic7xxx driver already has.
> Do you have any plans in that area?

I've no resources attributed to aic79xx at the moment.

But I'd like to say absolute kudos to James and Christoph for
making aic7xxx SPI transport aware!  Thumbs up!

	Luben

