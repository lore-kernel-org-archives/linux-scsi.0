From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC][PATCH] mark /proc/sys/dev/scsi/logging_level to be
	removed
Date: Thu, 20 Mar 2008 09:35:30 -0500
Message-ID: <1206023730.3038.9.camel@localhost.localdomain>
References: <1206018190-5888-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35443 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626AbYCTOfe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 10:35:34 -0400
In-Reply-To: <1206018190-5888-1-git-send-email-crquan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denis Cheng <crquan@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 21:03 +0800, Denis Cheng wrote:
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
> Since scsi_logging_level module_param can be read/written while system
> running, the demand for /proc/sys/dev/scsi/logging_level has been no longer
> mandotory.
> 
> But someone might have already set this value in /etc/sysctl.conf, so
> mark it to be removed in one year (until March 2009).
> 
> One year might be not enough or too long, this period should also be discussed.

I don't think there's really much point to doing this.  We're already tied to the SYS_SYSCTL deprecation Eric Biderman is hoping to do for this; it's much better if the whole lot goes at once rather than piecemeal (particularly if sysctl stays around longer than anticipated).

James


