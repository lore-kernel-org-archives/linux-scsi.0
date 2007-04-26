From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Kernel crash with AIC94xx (one step forward, hope it's lucky)
Date: Thu, 26 Apr 2007 13:17:02 -0700
Message-ID: <463108BE.20500@us.ibm.com>
References: <133536.33882.qm@web31804.mail.mud.yahoo.com> <4630770C.60209@gmail.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59631 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXDZUQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 16:16:48 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QKGmXJ031533
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 16:16:48 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QKGm8l491262
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 16:16:48 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QKGlYT010329
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 16:16:48 -0400
In-Reply-To: <4630770C.60209@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brailateo@gmail.com
Cc: ltuikov@yahoo.com, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Constantin Teodorescu wrote:

> So ... should I ask for other controller quotation ?
> Could you recommend me a good SAS controller, with 8 internal ports,
> supporting Linux , with 99.9999% reliability ? :-)
>=20
> I have the following options : Intel=AE RAID Controller SRCSAS18E
> (Parowan)  and   LSI MegaRAID SAS 8408E
>=20
> so ... your bet ? :-)

I don't know anything about either of those controllers, though the LSI
1068E has worked quite reliably for me.  I decline to make any
statements about 99.9999% reliability, however.

--D

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
