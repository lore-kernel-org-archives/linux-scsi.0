From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 0/7] Roll-up of libsas and aic94xx patches
Date: Mon, 29 Jan 2007 14:56:17 -0800
Message-ID: <45BE7B91.1020103@us.ibm.com>
References: <200701262206.l0QM6iCb017066@d01av02.pok.ibm.com> <45BAE434.6090306@torque.net>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53379 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932829AbXA2W4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 17:56:18 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0TMuIXg031611
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2007 17:56:18 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0TMuIf2554188
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2007 15:56:18 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0TMuHaw014762
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jan 2007 15:56:18 -0700
In-Reply-To: <45BAE434.6090306@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

Douglas Gilbert wrote:

> Darrick,
> The "reset the device" is a bit vague. Would that
> be a LU reset (task management function) or a
> "hard reset"? If the latter then it will cause
> collateral damage if the target contains multiple
> logical units (i.e. it will reset all of them,
> not just the one failing to spin up).

It's a hard reset.  After talking to Mike Anderson, it seems that
device_reset => LU reset and bus reset => phy reset are more appropriate
for SAS.  Will post patch shortly.

--D
