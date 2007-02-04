From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 12/12] sas_ata: Make this a module separate from libsas
Date: Sun, 04 Feb 2007 01:06:03 -0800
Message-ID: <45C5A1FB.1060205@us.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com> <20070130091903.31530.90178.stgit@elm3a70.beaverton.ibm.com> <1170518592.3345.38.camel@mulgrave.il.steeleye.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43296 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbXBDJGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Feb 2007 04:06:09 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l14966sg008197
	for <linux-scsi@vger.kernel.org>; Sun, 4 Feb 2007 04:06:06 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l14966P8065782
	for <linux-scsi@vger.kernel.org>; Sun, 4 Feb 2007 04:06:06 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l14966oN031643
	for <linux-scsi@vger.kernel.org>; Sun, 4 Feb 2007 04:06:06 -0500
In-Reply-To: <1170518592.3345.38.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, alexisb@us.ibm.com

James Bottomley wrote:
> On Tue, 2007-01-30 at 01:19 -0800, Darrick J. Wong wrote:
>> Break out sas_ata as a free-standing module that provides a SATA
>> Translation Layer (SATL) for libsas.  This patch requires the libsas
>> SATL registration patch; the changes to sas_ata itself are rather
>> minor.
> 
> Right at the moment, this doesn't work.  The dependency of ATA_AVAILABLE
> on SCSI_SAS_SATL forces libsas to require sas_ata if you select it as a
> module (i.e. they're not truly independent).
> 
> How about this solution to untangle them?

ACK.

--D
