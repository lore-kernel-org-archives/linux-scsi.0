From: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
Subject: Re: [PATCH 1/1] mvsas: add SGPIO support to Marvell 94xx
Date: Sun, 27 Dec 2015 21:30:23 +0100
Message-ID: <56804A5F.5040000@gmx.at>
References: <5645BEE0.3050406@gmx.at> <yq160zrp5jc.fsf@sermon.lab.mkp.net>
 <56803A2F.2030507@gmx.at> <1451245374.2283.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55162 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbbL0Ual (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Dec 2015 15:30:41 -0500
In-Reply-To: <1451245374.2283.2.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Am 27.12.15 um 20:42 schrieb James Bottomley:
> On Sun, 2015-12-27 at 20:21 +0100, Wilfried Weissmann wrote:
>> add SGPIO support to Marvell 94xx
>
> How do you actually use this?  It doesn't seem to be plumbed into the
> standard GPIO subsystem and there appears to be no user accessible
> interface for it either (nor is it used internally).
>
> There doesn't appear to be much point adding an unusable feature.

sas_domain_function_template.lldd_write_gpio exposes the interface to libsas. Userspace access is then done via ioctl(SG_IO,...). Existing user space tools such as ledmon use this method, also smp_utils in case you want to have more direct control.

Greetings,
Wilfried
