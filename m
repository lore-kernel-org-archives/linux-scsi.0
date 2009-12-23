From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Query related to block_device and gendisk relation
Date: Wed, 23 Dec 2009 09:09:28 -0500
Message-ID: <yq13a314w9z.fsf@sermon.lab.mkp.net>
References: <9ff69a5d0912230411saa76828v7fe4d506a9390ced@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mojo.mkp.net ([70.38.64.14]:47150 "EHLO mojo.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbZLWOhU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2009 09:37:20 -0500
In-Reply-To: <9ff69a5d0912230411saa76828v7fe4d506a9390ced@mail.gmail.com>
	(Prashant Bhole's message of "Wed, 23 Dec 2009 17:41:46 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>>>>> "Prashant" == Prashant Bhole <prashantsmailcenter@gmail.com> writes:

Prashant> Can anybody please tell me where does an object of gendisk
Prashant> gets assigned to struct block_device->bd_disk?

git grep -n "bd_disk ="

-- 
Martin K. Petersen	Oracle Linux Engineering
