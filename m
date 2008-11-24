From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_dh: Adding LSI vendor and product ids in  rdac
	device list
Date: Mon, 24 Nov 2008 09:04:45 +0900
Message-ID: <1227485085.25499.5.camel@localhost.localdomain>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE75982@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47056 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbYKXAEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2008 19:04:52 -0500
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BE75982@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sekharan@us.ibm.com" <sekharan@us.ibm.com>, "andmike@linux.vnet.ibm.com" <andmike@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>

On Mon, 2008-11-10 at 16:17 -0700, Moger, Babu wrote:
> From: Babu Moger <babu.moger@lsi.com>
> 
> This patch adds LSI vendor and product ids in rdac device handler.
> 
> Signed-off-by: Babu Moger <Babu.Moger@lsi.com>
> 
> ---
> 
> --- linux-2.6.28-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c.orig    2008-11-10 16:56:01.000000000 -0600
> +++ linux-2.6.28-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c 2008-11-10 16:56:20.000000000 -0600
> @@ -594,6 +594,8 @@ static const struct scsi_dh_devlist rdac
>         {"SUN", "LCSM100_F"},
>         {"DELL", "MD3000"},
>         {"DELL", "MD3000i"},
> +       {"LSI", "INF-01-00"},
> +       {"ENGENIO", "INF-01-00"},
>         {NULL, NULL},
>  };

This patch is whitespace damaged.  Your tabs have been converted to
spaces by your email tool.  I've fixed it up this time, since it was
only two lines, but please see

Documentation/email-clients.txt

For hints on how to get your MUA to work with patches.

James


