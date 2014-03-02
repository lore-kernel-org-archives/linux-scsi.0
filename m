From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv2 00/16] scsi_dh_alua updates
Date: Sun, 02 Mar 2014 10:10:12 +0100
Message-ID: <5312F574.7050906@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.6]:47527 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaCBJKQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Mar 2014 04:10:16 -0500
In-Reply-To: <1391160600-19652-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> here's an update for the ALUA device handler I've been hoarding
> for quite some time. The major bit here is the asynchronous
> RTPG handling. With the original design we would treat every
> LUN independently, despite the fact that several LUNs might
> in fact belong to the same target port group. So any
> change on one LUN will affect the others, too.
> And we now can treat LUNs in 'transitioning' ALUA mode
> correctly, as now we'll be blocking any I/O in the prep_fn()
> until the controller is in a working state again.

Also for this patch series, I think the cached INQUIRY data should be
refreshed at least after an INQUIRY DATA HAS CHANGED unit attention code
has been received.

Bart.

