From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 6/7] - MPT FUSION - SPLITTING SCSI HOST DRIVERS
Date: Mon, 28 Mar 2005 11:54:16 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01C2B0B8@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55187 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261995AbVC1SyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 13:54:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sunday, March 27, 2005 8:04 AM, James Bottomley wrote:
> 
> 
> On Sun, 2005-03-27 at 01:16 -0800, Jeremy Higdon wrote:
> > James, actually this queue depth code predates your 
> change_queue_depth
> > API.  I don't think it was ever converted to the new API.
> 
> Erk, you're right.  My todo list says I'm only waiting on 
> 3ware patches
> for all the conversions to be complete, but I think I missed auditing
> fusion because it's not in the scsi directory...OK I'll do it after we
> get the driver split sorted out.
> 
> James
> 
>

I can probably look into adding this support once we get the slit drivers
accepted.

Thankyou,
Eric
 
