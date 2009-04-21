From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 0/14 - 2nd post] mpt2sas: driver version 01.100.02.00
Date: Tue, 21 Apr 2009 08:08:09 -0700
Message-ID: <660360F4F2570145BD872F298951B17A76BCB2F2@cosmail03.lsi.com>
References: <20090417162404.GA7009@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og62.obsmtp.com ([64.18.14.201]:54804 "EHLO
	chip3og62.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZDUPIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 11:08:25 -0400
In-Reply-To: <20090417162404.GA7009@lsil.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James - Can you please push these patchs into 2.6.30-rc ?

Thankyou,
Eric Moore

On Friday, April 17, 2009 10:24 AM, Eric Moore wrote:
> 
> 2nd Post:
> Per Martin Petersen suggestions on T10 DIF - For type 1 protection
> only set reference and gaurd tag checking.  For type 3 protection only
> set guard tag checking.  Deleted the calling of scsi_host_set_guard.
> 
> 1st Post:
> Here is set of misc bug fix's, to include T10 DIF support, 
> and Lun Reset
> Support.
> 
> Please consider for inclusion.
> 
> Signed-off-by: Eric Moore <eric.moore@lsi.com>
> 
> [PATCH 1/14 - 2nd post] mpt2sas: unique ioctl magic number
> [PATCH 2/14 - 2nd post] mpt2sas: the sanity check in 
> base_interrupt needs to be on dword boundary
> [PATCH 3/14 - 2nd post] mpt2sas: fix oops when firmware sends 
> large sense buffer size
> [PATCH 4/14 - 2nd post] mpt2sas: running out of message frames
> [PATCH 5/14 - 2nd post] mpt2sas: driver name needs to be in 
> the MPT2IOCINFO ioctl
> [PATCH 6/14 - 2nd post] mpt2sas: Identify Dell series-7 
> adapters at driver load time.
> [PATCH 7/14 - 2nd post] mpt2sas: Broadcast Primative AEN bug fix.
> [PATCH 8/14 - 2nd post] mpt2sas: release diagnotic buffers 
> prior host reset
> [PATCH 9/14 - 2nd post] mpt2sas: T10 DIF Support - EEDP
> [PATCH 10/14 - 2nd post] mpt2sas: LUN Reset Support
> [PATCH 11/14 - 2nd post] mpt2sas: add query task support for 
> MPT2COMMAND  ioctl
> [PATCH 12/14 - 2nd post] mpt2sas: using the same naming 
> convention for all static function
> [PATCH 13/14 - 2nd post] mpt2sas: fix hotplug event processing
> [PATCH 14/14 - 2nd post] mpt2sas: bump driver version to 01.100.02.00
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 