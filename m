From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 16:33:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924233346.GE1330@beaverton.ibm.com>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924233941.A9952@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020924233941.A9952@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Russell King [rmk@arm.linux.org.uk] wrote:

looks good.

One nit is that scsi_report_bus_reset sets was_reset which is only
called by two drivers I currently see. The new code does not catch this
case, but the trade of is probably worth it.

-andmike
--
Michael Anderson
andmike@us.ibm.com

