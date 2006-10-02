From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport is blocked.
Date: Mon, 2 Oct 2006 16:14:24 -0600
Message-ID: <20061002221424.GP16272@parisc-linux.org>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49792 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S965443AbWJBWOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 18:14:25 -0400
Content-Disposition: inline
In-Reply-To: <452167C8.3010401@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

On Mon, Oct 02, 2006 at 03:26:00PM -0400, James Smart wrote:
> - Fix the error handler. (but we all know this is a lot of work,
>     of which none of us have the time to do, nor expect it to
>     be complete in time for our next distro delivery).

Can't you fix this in the driver instead?  Seems to me that
.eh_timed_out in the SHT would be enough to fix this case.  Just keep
returning EH_RESET_TIMER until the condition expires.
