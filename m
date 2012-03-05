From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RESEND PATCH] mptsas: Fixed code to check whether the LU type
 is SSC or not for SILI bit in READ_6 and READ_16 CDB
Date: Mon, 5 Mar 2012 08:41:22 -0800
Message-ID: <20120305164122.GC2459@kroah.com>
References: <201203050453.q254rqa5002619@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50650 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab2CEQxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2012 11:53:41 -0500
Received: by mail-pz0-f52.google.com with SMTP id p12so5333803dad.11
        for <linux-scsi@vger.kernel.org>; Mon, 05 Mar 2012 08:53:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <201203050453.q254rqa5002619@milmhbs0.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, jejb@kernel.org

On Mon, Mar 05, 2012 at 10:24:31AM +0530, nagalakshmi.nandigama@lsi.com wrote:
> This SILI bit (suppress incorrect length indicator) is defined only for SSC
> READ(6) and READ(16) commands. For other device types bit is part of LBA
> field. In the current implementation, it is not checked whether the logical
> unit is a SSC device.
> 
> 
> Added code for checking the LU type is SSC for SILI bit in READ_6 and READ_16 CDB 
> 
> Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
> CC: <stable@kernel.org>
> ---

Note, that is NOT the stable email address, you got it right in the cc:
for the email, but not here, please fix it.

greg k-h
