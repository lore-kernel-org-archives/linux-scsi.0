From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Fri, 18 Aug 2006 23:11:17 -0500
Message-ID: <44E68F65.2000701@cs.wisc.edu>
References: <1155936609.12933.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37012 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932365AbWHSELZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 00:11:25 -0400
In-Reply-To: <1155936609.12933.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> +/*
> + * Vendor ID:
> + *   If transports post vendor-unique events, they must pass a well-known
> + *   32-bit vendor identifier. This identifier consists of 8 bits indicating
> + *   the "type" of identifier contained, and 24 bits of id data.
> + *
> + *   Identifiers for each type:
> + *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
> + */
> +#define SCSI_NL_VID_ID_MASK			0x00FFFFFF
> +#define SCSI_NL_VID_TYPE_MASK			0xFF000000
> +#define SCSI_NL_VID_TYPE_PCI			0x01000000
> +

Would it be possible to make this a little larger? For iscsi we wanted
to use the MAC address. It can wait. I do not care if it goes in now or
later. I just don't want to be the first one to break apps by changing
the number and seeing how many checked version numbers :)
