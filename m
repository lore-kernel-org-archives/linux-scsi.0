From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH as468] Retry supposedly "unrecoverable" hardware errors
Date: Thu, 17 Feb 2005 09:11:47 -0600
Message-ID: <1108653107.5507.3.camel@mulgrave>
References: <Pine.LNX.4.44L0.0502161144170.6418-100000@ida.rowland.org>
	 <42141D3D.9080800@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:15252 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262244AbVBQPM3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 10:12:29 -0500
In-Reply-To: <42141D3D.9080800@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Martin Peschke <mpeschke@de.ibm.com>, Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-02-17 at 14:27 +1000, Douglas Gilbert wrote:
> Recent SPC-3 and SBC-2 drafts treat the sense keys of
> MEDIUM ERROR and HARDWARE ERROR in a similar way.
> Both can return an "info" field which has the same
> meaning (lba of first failure). The distinction is that
> MEDIUM ERROR is a little more precise (at least for
> magnetic rotating media) **. For flash ram the distinction
> is moot.

My copy of SPC-3 (r21d) still defined HARDWARE ERROR in Table 27 as

HARDWARE ERROR: Indicates that the device server detected a non-
recoverable hardware failure
(e.g., controller failure, device failure, or parity error) while
performing the command or during a self
test.

which looks pretty non-retryable to me ... where does it say that the
error might be retryable?

James


