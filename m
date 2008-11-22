From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SES monitoring
Date: Sat, 22 Nov 2008 16:11:45 -0500
Message-ID: <49287591.1050601@interlog.com>
References: <49286F86.6080101@sauce.co.nz>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44278 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYKVVLz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Nov 2008 16:11:55 -0500
In-Reply-To: <49286F86.6080101@sauce.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-scsi@vger.kernel.org

Richard Scobie wrote:
> Are there any utilities around to monitor enclosure ses data?
> 
> I have found safte-monitor for SAF-TE enabled enclosures, but this does 
> not apply to the enclosures in use here:
> 
> scsi 8:0:16:0: Enclosure         AIC      ED16-53C-01A2    114H PQ: 0 
> ANSI: 5
> scsi 8:0:16:0: Attached scsi generic sg18 type 13
> ses 8:0:16:0: Attached Enclosure device

Richard,
Try sg_ses in the sg3_utils package found at
   http://sg.danny.cz/sg/sg3_utils.html

Doug Gilbert


