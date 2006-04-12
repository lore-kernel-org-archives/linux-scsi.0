From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] aic7xxx: deinline large functions, save 80k of text
Date: Wed, 12 Apr 2006 15:55:42 +0200
Message-ID: <443D06DE.8060903@suse.de>
References: <200604120945.34419.vda@ilport.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:14466 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751034AbWDLNz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Apr 2006 09:55:58 -0400
In-Reply-To: <200604120945.34419.vda@ilport.com.ua>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denis Vlasenko <vda@ilport.com.ua>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arjan@infradead.org, gibbs@scsiguy.com, eike-kernel@sf-tec.de, stefanr@s5r6.in-berlin.de

Denis Vlasenko wrote:
> This patch
>=20
> moves big inlines into aic79xx_core.c and aic7xxx_core.c
> makes ahd_delay just a wrapper around udelay
> marks a few functions static
> fixes spelling fix in error message
While you're at it; can't you move the different ah{c,d}_{in,out}.* int=
o
one place? Have them scattered throughout the file doesn't really make
sense.

Otherwise ACK.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
