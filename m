From: Rob Love <robert.w.love@linux.intel.com>
Subject: Re: [OpenFCoE PATCH] [PATCH] Performance improvement,	combine received
 data copy with CRC.
Date: Thu, 06 Dec 2007 17:09:46 -0800
Message-ID: <47589D5A.10501@linux.intel.com>
References: <20071205005224.26269.68039.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:8895 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752599AbXLGBNz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 20:13:55 -0500
In-Reply-To: <20071205005224.26269.68039.stgit@mink.he.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <fcoe@eykholt.com>
Cc: linux-scsi@vger.kernel.org

Joe Eykholt wrote:
> [PATCH] Performance improvement, combine received data copy with CRC.
>   
Shouldn't we remove  openfc_cp_to_user() if we're moving that 
functionality into openfc_scsi_recv_data()? I don't see anything calling 
it anymore. My guess is that your leaving it in there for future usage, 
but my argument would be to remove it since it's not being used and then 
add it back if needed in the future.
