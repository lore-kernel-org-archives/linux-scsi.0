From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH] aacraid: Add module param to export disks as 'fixed'
 instead of 'removable'
Date: Fri, 20 May 2011 18:29:43 +0530
Message-ID: <4DD665BF.4080502@suse.de>
References: <4DD2CE01.9090403@suse.de> <20110517193544.GA27336@infradead.org> <FC1F9E38C0703341A1A750524E2525A9017776E1@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab1ETM60 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 08:58:26 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9017776E1@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, aacraid@adaptec.com, Hannes Reinecke <hare@suse.de>

On 05/19/2011 01:51 AM, Mark Salyzyn wrote:
>> On Wed, May 18, 2011 at 01:05:29AM +0530, Ankit Jain wrote:
>>> aacraid: Add 'aac_export_fixed' module param to export disks as
>>> 'fixed' instead of 'removable'.
>>> Adaptec controllers set the removable flag on devices to
>>> allow for reconfiguration. The fear is that _not_ setting this
>>> flag would inhibit the OS from detecting any device reconfiguration.
>> The flag should not be set at all and just be removed.
> 
> This will break the RAID Management Software, and various Firmware
> features (snapshot, thin-provisioning etc)

I'm trying to get a better understanding. How do the RAID management
software and firmware features depend on this?

-- 
Ankit Jain
SUSE Labs
