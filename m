From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] sd: add support for TCG OPAL self encrypting disks
Date: Tue, 13 Jun 2017 08:40:18 +0200
Message-ID: <20170613064018.GA31330@lst.de>
References: <20170604124225.27032-1-hch@lst.de> <20170604124225.27032-7-hch@lst.de> <yq1lgp6djr3.fsf@oracle.com> <20170606095802.GA20590@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170606095802.GA20590@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2017 at 11:58:02AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 05, 2017 at 08:48:00PM -0400, Martin K. Petersen wrote:
> > For WRITE SAME, scsi_report_opcode() is gated not only by
> > sdev->no_report_opcodes but by sdev->no_write_same.
> > 
> > I'm concerned about firing off REPORT OPCODES to random devices without
> > a sufficiently good heuristic. Doesn't look like SAT has anything to
> > offer in this department, though. Maybe it's time to consider a
> > vendor-specific Linux VPD page...
> 
> Eww.  Given that as far as I can tell only ATA devices implement
> OPAL we could key it off that for now.  But that's only going to
> defer the problem until support for other security protocols comes
> along for real SCSI devices.
> 
> But as we already set no_report_opcodes for all usb-storage and
> quirked uas devices I think the worst offenders are already covered
> anyway.

Martin, how do we want to move ahead on this patch?
