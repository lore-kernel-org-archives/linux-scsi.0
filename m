From: Joe Malicki <jmalicki@metacarta.com>
Subject: Re: megaraid_sas waiting for command and then offline
Date: Tue, 12 Dec 2006 13:40:28 -0500
Message-ID: <457EF79C.9030009@metacarta.com>
References: <457E1C59.80208@metacarta.com> <457E3D0D.7070707@imvu.com>	 <457E43BE.9040806@metacarta.com> <1165926657.4991.132.camel@edinburgh.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silene.metacarta.com ([65.77.47.18]:40034 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbWLLSlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 13:41:31 -0500
In-Reply-To: <1165926657.4991.132.camel@edinburgh.max-t.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Dickie <greg@max-t.com>
Cc: "Brett G. Durrett" <brett@imvu.com>, linux-scsi@vger.kernel.org, linux-poweredge@dell.com, "David N. Welton" <d.welton@webster.it>, Sumant Patro <Sumant.Patro@lsil.com>, "Marc A. Meadows" <mam+megaraid@metacarta.com>, "Keith R. Baker" <krbaker+megaraid@metacarta.com>

Thanks Greg,

Is there documentation or tests of the number of commands per LUN that
the hardware can handle?  The driver is clearly reading the value out of
a register on the card.

thanks,
joe

Greg Dickie wrote:
> We've never had lockups like this but we did notice that the
> megaraid_sas modules defaults to a much higher commands per lun setting
> than the hardware seems to be able to handle. IIRC the default is 128
> and we lowered it to 16 for the 5i and 32 for the 5E.
> 
> HTH,
> Greg
> 
> 

