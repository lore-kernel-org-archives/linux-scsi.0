From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: 26 May 2004 09:45:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085582747.2115.132.camel@mulgrave>
References: <OF674A6508.2E30D394-ONC1256EA0.003A71C5-C1256EA0.00493D5D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:17589 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S265604AbUEZPZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 11:25:13 -0400
Received: from hancock.sc.steeleye.com (stat1.steeleye.com [65.114.3.130])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id i4QEn23m032738
	for <linux-scsi@vger.kernel.org>; Wed, 26 May 2004 07:49:16 -0700
In-Reply-To: <OF674A6508.2E30D394-ONC1256EA0.003A71C5-C1256EA0.00493D5D@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-05-26 at 08:14, Martin Peschke3 wrote:
> Is there a SCSI mid layer interface that allows an lldd to get a
> SCSI devices back online?

actually

echo "running" > /sys/...<device path>.../state

will work from user land.

Really, it isn't safe for a LLD to try to bring a device back online on
its own without user intervention.

James


