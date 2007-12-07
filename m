From: Joe Eykholt <fcoe@eykholt.com>
Subject: Re: [OpenFCoE PATCH] [PATCH] Performance improvement,	combine received
 data copy with CRC.
Date: Thu, 06 Dec 2007 17:29:10 -0800
Message-ID: <4758A1E6.6010903@eykholt.com>
References: <20071205005224.26269.68039.stgit@mink.he.net> <47589D5A.10501@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:36846 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752877AbXLGB27 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Dec 2007 20:28:59 -0500
Received: from 67.91.200.194 ([67.91.200.194]) by eykholt.com for <linux-scsi@vger.kernel.org>; Thu, 6 Dec 2007 17:28:58 -0800
In-Reply-To: <47589D5A.10501@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Love <robert.w.love@linux.intel.com>
Cc: linux-scsi@vger.kernel.org

Rob Love wrote:
> Joe Eykholt wrote:
>> [PATCH] Performance improvement, combine received data copy with CRC.
>>   
> Shouldn't we remove  openfc_cp_to_user() if we're moving that
> functionality into openfc_scsi_recv_data()? 

Yes.  That was an oversight.  I did intend to remove it.
Do you want a new patch for that or will you take care of it?

	Joe

> I don't see anything calling
> it anymore. My guess is that your leaving it in there for future usage,
> but my argument would be to remove it since it's not being used and then
> add it back if needed in the future.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
