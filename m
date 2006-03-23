From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Thu, 23 Mar 2006 13:37:23 -0500
Message-ID: <1143139044.3415.26.camel@mulgrave.il.steeleye.com>
References: <20051114224512.GF9905@mathom.us>
	 <20060323180909.GD15140@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:35214 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932473AbWCWSha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 13:37:30 -0500
In-Reply-To: <20060323180909.GD15140@mathom.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stone <mstone@mathom.us>
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-03-23 at 13:09 -0500, Michael Stone wrote:
> The negotiation for this configuration is still broken in 2.6.16.

Well, since the driver works normally for most people, it sounds like
there's some issue with this configuration.  First of all, look
in /sys/class/spi_transport/target2:0:0 and tell me what min_period,
max_offset and max_width are.  Then, if min_period is too high, echo
12.5 to it and 1 to revalidate.  Finally, see if you can set the period
yourself using the period file.  Also, what does /proc/scsi/aic79xx/2
say?  If none of that works, we can try debug the negotiation.

James


