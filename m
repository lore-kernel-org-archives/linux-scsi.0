From: "Robert Tarte" <robt@PacificCodeWorks.com>
Subject: RE: aic94xx status
Date: Tue, 11 Jul 2006 01:32:40 -0700
Message-ID: <16C8363E16D7234AB844FDB52D4AEA650C2DB7@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-67-101-118-101.snfccasy.covad.net ([67.101.118.101]:17816
	"EHLO PacificCodeWorks.com") by vger.kernel.org with ESMTP
	id S1750744AbWGKI2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2006 04:28:12 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

> 1) SATA support.  We at least need this stubbed out so seeing a SATA
> device won't cause nasty things to happen (IBM is working on this).
> Ideally, we need to integrate this driver with Brian King's SATA/SAS
> code, but no-one who has this board has a sata device and vice versa.

[Tarte, Robert] I'm not sure what Brian King's SATA/SA code is, but I do
have boards that use the razor chip and I have SATA devices.

