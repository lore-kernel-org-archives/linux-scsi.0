From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Thu, 28 Oct 2004 13:37:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028113728.GT32712@marowsky-bree.de>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:57044 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S262248AbUJ1Ryg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 13:54:36 -0400
Content-Disposition: inline
In-Reply-To: <1098914250.1588.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-27T17:57:21, James Bottomley <James.Bottomley@SteelEye.com> =
wrote:

> It's not occasional, it happens every time a single machine in the
> cluster reboots and the HSG80 can take a while to transfer luns.=20
> Configure one with several hundred luns in a 32 node cluster and you'=
ll
> see why this flag exists...

While we are at that, ghost (or non-active) paths lead to _tons_ of
errors while the kernel stubbornly tries to read the partition table,
totally flooding any useful information out of the kernel buffers.

Can't we do a test-unit-ready before trying to read and then just not
read the partition table w/o so much noise?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
