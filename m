From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] SCSI: Synchronization issue while deleting vport
Date: Fri, 22 Jan 2010 21:00:57 -0500
Message-ID: <4B5A5859.1010006@emulex.com>
References: <1264061732.31083.51.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:6657 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750745Ab0AWU1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jan 2010 15:27:09 -0500
In-Reply-To: <1264061732.31083.51.camel@galr-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Gal,

Thanks for correcting this issue.  Patch looks good.

Signed-off-by: James Smart <james.smart@emulex.com>



Gal Rosen wrote:
> Hi,
> 
> Attach proposed patch for the PROBLEM: Synchronization issue in
> scsi_transport_fc.
> 
> Gal Rosen.
> 

