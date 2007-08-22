From: =?iso-8859-1?Q?Bj=F6rn?= Stenberg <bjorn@haxx.se>
Subject: Re: isd200.c Has fatal bugs and is probably not used any more
Date: Wed, 22 Aug 2007 10:42:07 +0200
Message-ID: <20070822084207.GA30803@giant>
References: <46CB37B2.404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from giant.haxx.se ([83.168.254.42]:36341 "EHLO giant.haxx.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263AbXHVIzO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2007 04:55:14 -0400
Content-Disposition: inline
In-Reply-To: <46CB37B2.404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: support@in-system.com, James Bottomley <James.Bottomley@SteelEye.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> The last git recorded real change to this driver was it's insertion
> into git by Linus.
>=20
> Is this an indication that this driver is no longer used and
> can be removed?

It is definitely used. The driver was introduced for a line of Archos M=
P3 players which are still in active use. The Rockbox projects gets aro=
und 500 firmware downloads for these players every month.

(Please cc me on replies, I am not on the list.)
--=20
Bj=F6rn
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
