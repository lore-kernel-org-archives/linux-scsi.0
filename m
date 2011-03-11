From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Logical Block Provisioning (SBC3r26)
Date: Fri, 11 Mar 2011 10:22:24 -0500
Message-ID: <4D7A3E30.6030500@interlog.com>
References: <yq1oc5mcco4.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56717 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab1CKPW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 10:22:28 -0500
In-Reply-To: <yq1oc5mcco4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com

On 11-03-08 02:08 AM, Martin K. Petersen wrote:
>
> Update scsi_debug to support the Logical Block Provisioning commands and
> bits as defined in SBC3r26. The old tp* parameters have been
> transitioned to the new lbp* scheme found in the draft standard.
>
> The old tpu option to enable UNMAP is now called lbpu. tpws to signal
> support for WRITE SAME(16) with the UNMAP bit set is now lbpws. Support
> for WRITE SAME(10) with the UNMAP bit set is also available using the
> lpuws10 parameter.
>
> Limiting the maximum number of blocks per WRITE SAME command has been
> implemented and is available via the write_same_length module parameter.
>
> As part of the renaming process the parameter lists have been sorted
> alphabetically (request from Doug).
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>

Looks good. Thanks for that. I have a small add on patch
to extend the medium error (opts=2) to 10 consecutive
blocks. See following post.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
