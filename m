From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH as468] Retry supposedly "unrecoverable" hardware errors
Date: Thu, 17 Feb 2005 10:20:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502171018040.1034-100000@ida.rowland.org>
References: <42142644.6080005@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:3844 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262257AbVBQPUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 10:20:23 -0500
In-Reply-To: <42142644.6080005@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Martin Peschke <mpeschke@de.ibm.com>, Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 17 Feb 2005, Douglas Gilbert wrote:

> ... after a bit further thought, a retry (arguably) is only
> needed when an unrecoverable (data) error is detected. If we
> assume the "info" field indicates an unrecoverable error
> then the following patch combines the processing of
> MEDIUM and HARDWARE ERROR sense keys without the need for
> a black list category.

Your assumption is not a good one.  In the particular case that led me to 
submit this patch, the device returns Valid = 0, with no "info" data.  
Nevertheless, retrying fixes the problem, whereas your patch won't help.

Alan Stern

