From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Thu, 28 Oct 2004 20:21:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028182154.GY32712@marowsky-bree.de>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave> <20041028113728.GT32712@marowsky-bree.de> <20041028181436.GA18874@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:61931 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S263359AbUJ2Omg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 10:42:36 -0400
Content-Disposition: inline
In-Reply-To: <20041028181436.GA18874@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-28T11:14:36, Patrick Mansfield <patmans@us.ibm.com> wrote:

> > Can't we do a test-unit-ready before trying to read and then just n=
ot
> > read the partition table w/o so much noise?
> We already issue a TUR in sd_spinup_disk() prior to the READ CAPACITY=
 and
> partition reads.

I'm just saying we should stop on the first failed command (TUR) and no=
t
retry to read all 64 sectors regardless. I can live with one error per
passive path, but 64 really kills the logs.


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
