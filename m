From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCHES 0/9] osd patches for 2.6.33 merge window -
 resend
Date: Mon, 23 Nov 2009 18:34:03 +0200
Message-ID: <4B0AB97B.7@panasas.com>
References: <4B019BEC.3080909@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:1968 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755212AbZKWQeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2009 11:34:01 -0500
In-Reply-To: <4B019BEC.3080909@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 11/16/2009 08:37 PM, Boaz Harrosh wrote:
> James hi.
> 
> It's getting near the next merge window and none of the osd patches made it
> into scsi-misc yet. I would not like to miss it like last time.
> 

James what is the disposition on these patches?
Linus said he's going to release soon.

> All these are exactly as posted in the mailing list, latest version:
> 
> [PATCH 1/9] libosd: osd_dev_is_ver1 - Minor API cleanup
> [PATCH 2/9] libosd: osd_sense: OSD_CFO_PERMISSIONS
> [PATCH 3/9] osduld: Ref-counting bug fix
> [PATCH 4/9] osduld: Use device->release instead of internal kref
> [PATCH 5/9] libosd: osd_dev_info: Unique Identification of an OSD device
> [PATCH 6/9] libosd: bug in osd_req_decode_sense_full()
> [PATCH 7/9] libosd: Bugfix of error handling in attributes-list decoding
> [PATCH 8/9] libosd: Error handling revamped
> [PATCH 9/9] osd_protocol.h: Add missing #include

plus this one:
[PATCH 10/10] osduld: No need to use dev_set_drvdata on embedded devices

> 
> Thanks
> Boaz

Boaz
