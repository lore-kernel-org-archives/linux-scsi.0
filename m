From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Any multipath SAS support in Linux?
Date: Wed, 14 Feb 2007 17:53:18 -0800
Message-ID: <45D3BD0E.7080705@us.ibm.com>
References: <er079a$b45$1@sea.gmane.org>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50590 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781AbXBOBxY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 20:53:24 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1F1rMsr005010
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2007 20:53:22 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1F1rMd8250508
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2007 20:53:22 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1F1rLqQ016609
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2007 20:53:22 -0500
In-Reply-To: <er079a$b45$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Orion Poplawski <orion@cora.nwra.com>
Cc: linux-scsi@vger.kernel.org

Orion Poplawski wrote:
> I'm thinking about trying to setup a two node HA storage cluster
> connected to an external SAS box.  Is such a thing possible at this time?

I've had success with aic94xx + dm_multipath before.  There has recently
been a bug in the multipath tools wherein it fails to detect disk type
due to the removal of a "bus" attribute in sysfs. and I don't know if
that's been fixed.  (Aside from building your own with the sysfs part
removed....)

Note that success == I set it up, started I/O, yanked some cables, and
it kept chugging. :)

--D
