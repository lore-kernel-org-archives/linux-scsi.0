From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] megaraid: Downgrade two success messages to info
Date: Wed, 4 May 2016 08:50:40 +0200
Message-ID: <57299BC0.3040304@suse.de>
References: <7e71f78a77208ec3f46f44e8c6dc6ebcff26c2ce.1462296213.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbcEDGum (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2016 02:50:42 -0400
In-Reply-To: <7e71f78a77208ec3f46f44e8c6dc6ebcff26c2ce.1462296213.git.luto@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

On 05/03/2016 07:24 PM, Andy Lutomirski wrote:
> I actually read the error messages in my logs, and successful
> initialization is not an error.
>=20
> Arguably these log lines could be deleted entirely.
>=20
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>=20
> Changes from v2: Remove hunk that didn't belong
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
