From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [PATCH 2.4] fix for scsi_unjam_host: Miscount of number of failed commands
Date: Sun, 7 Nov 2004 10:17:03 -0200
Message-ID: <20041107121703.GB28453@logos.cnet>
References: <04Nov1.162549est.333220@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9878 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261625AbUKGPay
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Nov 2004 10:30:54 -0500
Content-Disposition: inline
In-Reply-To: <04Nov1.162549est.333220@cyborg.cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 01, 2004 at 04:26:12PM -0500, Tony Battersby wrote:
> This is a resend of http://marc.theaimsgroup.com/?l=linux-scsi&m=108438814301446&w=2
> 
> This patch fixes a panic "scsi_unjam_host: Miscount of number of failed
> commands".  This panic happens only under very specific circumstances:
> 
> 1) A command fails with check condition
> 2) The low-level driver doesn't auto-retrieve the sense data
> 3) The sense key is "not ready" and ASC/ASCQ indicate the unit is becoming
> ready
> 4) A retry of the command fails in the same way

Tony, 

I'm about to release 2.4.28-rc2 which should become final, 
I've queued your patches for 2.4.29-pre. 

Thanks
