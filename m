From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Thu, 16 Dec 2004 10:54:12 +0100
Message-ID: <1103190852.4136.12.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458B7F5071@otce2k01.adaptec.com>
	 <1102536081.4218.0.camel@localhost.localdomain>
	 <20041215072453.GB17274@lists.us.dell.com>
	 <1103136559.5232.1.camel@mulgrave>
	 <20041215213001.GA9284@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:49681 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S262487AbULPJyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 04:54:31 -0500
In-Reply-To: <20041215213001.GA9284@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, brking@us.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Wed, 2004-12-15 at 15:30 -0600, Matt Domsch wrote:
> Do you plan to apply LSI's driver patch which adds the driver-private
> ioctl to provide the mapping from logical drive address to HCTL value?
> Both Dell and LSI have products which are lined up to use this new
> ioctl because it's the most expedient thing to do, maintains internal
> project schedules, etc, which delaying until this sysfs mechanism hits
> will greatly impact those schedules. (I know, many folks on this list
> don't care about business-side impacts of choices made on-list.)

I'm strongly against adding this. The reason for that is that once an
ioctl is added, it realistically will and can never go away.
LSI is free to have their own fork and give that to dell; but they
should and could have known that it wasn't going to fly. (same I guess
for adaptec ioctls). The companies who then commit to some schedule
realize they take a huge risk, but that is no reason to foul up the
kernel more. 

