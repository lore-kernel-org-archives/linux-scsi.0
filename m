From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Tue, 21 Feb 2006 22:26:02 -0800
Message-ID: <20060222062602.GA30870@us.ibm.com>
References: <20060217023613.GA30583@us.ibm.com> <1140549399.3215.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:17311 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751342AbWBVG3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 01:29:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1M6T6Ot016070
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 01:29:06 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1M6T6Ll219778
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 01:29:06 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1M6T6hF017273
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 01:29:06 -0500
Content-Disposition: inline
In-Reply-To: <1140549399.3215.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Tarte@us.ibm.com, Robert <Robert_Tarte@adaptec.com>, Jeff Garzik <jgarzik@redhat.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> Actually, it's still not quite working for me.  This is what I get from
> 2.6.16-rc4 with the Jeff Garzik SAS tree (which has this fix applied).
> The soft lockup basically means it was hung in asd_read_ocm():

ok, looking into this. Is the soft lockup detect in the same
(asd_read_ocm+0x120) function and offset. I did a resync with Jeff's tree
and ran the code on a ppc64 system. This ran ok. I will move my card to an
IA64 tomorrow to see if I can recreate (which may be unlikely as it ran a
number of loads before) and also generate a .lst file.

-andmike
--
Michael Anderson
andmike@us.ibm.com
