From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mptsas: Added code for checking the LU type is SSC for
 SILI bit in READ_6  and READ_16 CDB
Date: Fri, 2 Mar 2012 07:38:17 -0800
Message-ID: <20120302153817.GB27141@kroah.com>
References: <201203020956.q229uGR2002732@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62666 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030370Ab2CBPrz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2012 10:47:55 -0500
Received: by mail-pw0-f46.google.com with SMTP id un15so233980pbc.19
        for <linux-scsi@vger.kernel.org>; Fri, 02 Mar 2012 07:47:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <201203020956.q229uGR2002732@milmhbs0.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, jejb@kernel.org

On Fri, Mar 02, 2012 at 03:26:55PM +0530, nagalakshmi.nandigama@lsi.com wrote:
> Added code for checking the LU type is SSC for SILI bit in READ_6  and READ_16 CDB 
> 
> Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
> ---

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
