From: Brian King <brking@us.ibm.com>
Subject: Re: aic94xx status
Date: Thu, 20 Jul 2006 09:39:28 -0500
Message-ID: <44BF95A0.1090703@us.ibm.com>
References: <16C8363E16D7234AB844FDB52D4AEA650C2DB7@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:61916 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932582AbWGTOod (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jul 2006 10:44:33 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6KEiVHG032749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2006 10:44:32 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6KEiT5n198368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2006 10:44:32 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6KEiTgO006128
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2006 10:44:29 -0400
In-Reply-To: <16C8363E16D7234AB844FDB52D4AEA650C2DB7@ntserv.PacificCodeWorks.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Tarte <robt@PacificCodeWorks.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

Robert Tarte wrote:
>> 1) SATA support.  We at least need this stubbed out so seeing a SATA
>> device won't cause nasty things to happen (IBM is working on this).
>> Ideally, we need to integrate this driver with Brian King's SATA/SAS
>> code, but no-one who has this board has a sata device and vice versa.
> 
> [Tarte, Robert] I'm not sure what Brian King's SATA/SA code is, but I do
> have boards that use the razor chip and I have SATA devices.

The patch referred to here is a patch to libata that adds a set of APIs
that allows a SAS HBA to hook into libata to control SATA devices. It
was written so that I could get ipr to hook into libata, and the hope
is that it could be used by other SAS drivers as well. Unfortunately,
no other SAS drivers that support SATA passthrough have really tried
using it yet.

http://marc.theaimsgroup.com/?l=linux-ide&m=115279779219927&w=2

Brian


