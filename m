From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REPOST][PATCH] FC transport : Avoid device offline cases by stalling aborts until device unblocked
Date: Fri, 10 Mar 2006 16:13:33 +0000
Message-ID: <20060310161333.GA5992@infradead.org>
References: <43E8B19F.8050006@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:1508 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751173AbWCJQNe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 11:13:34 -0500
Content-Disposition: inline
In-Reply-To: <43E8B19F.8050006@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Feb 07, 2006 at 09:41:35AM -0500, James Smart wrote:
> Following the recommendation from Christoph....
> 
> This moves the eh_timed_out functionality from the scsi_host_template
> to the transport_template. Given that this is now a transport function,
> the EH_RESET_TIMER case no longer caps the timer reschedulings. The
> transport guarantees that this is not an infinite condition.
> 
> This patch is dependent upon Christoph's change of:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113923531412919&w=2

James, could you put this into scsi-misc?  I've just reposted the
prerequisite megaraid_sas patch.

