From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 1/3] Synchronization of cmds during termination
 conditions
Date: Wed, 12 Oct 2016 08:20:17 +0200
Message-ID: <20161012062017.GA24520@kroah.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476226685-2276-2-git-send-email-mikecyr@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbcJLGUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 02:20:22 -0400
Content-Disposition: inline
In-Reply-To: <1476226685-2276-2-git-send-email-mikecyr@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Cyr <mikecyr@us.ibm.com>
Cc: nab@linux-iscsi.org, joe@perches.com, hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

On Tue, Oct 11, 2016 at 05:58:03PM -0500, Michael Cyr wrote:
> Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>

I almost never accept patches with no changelog information.  For a
patch that changes 1082 lines in a non-trivial way, you would think that
you could explain why you are doing this work...

Also, check the prefix of your subject, it give no clue as to where in
the kernel your patches touch :(

thanks,

greg k-h
