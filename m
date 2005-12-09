From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 11:40:13 +0000
Message-ID: <20051209114013.GA16945@infradead.org>
References: <20051208133945.GA21633@srcf.ucam.org> <20051208134438.GA13507@infradead.org> <1134062330.1732.9.camel@localhost.localdomain> <43989B00.5040503@pobox.com> <20051208133144.0f39cb37.randy_d_dunlap@linux.intel.com> <1134121522.27633.7.camel@localhost.localdomain> <20051209103937.GE26185@suse.de> <1134125145.27633.32.camel@localhost.localdomain> <43996A26.8060700@pobox.com> <1134128127.27633.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1134128127.27633.39.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Erik Slagter <erik@slagter.name>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>, Randy Dunlap <randy_d_dunlap@linux.intel.com>, hch@infradead.org, mjg59@srcf.ucam.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 09, 2005 at 12:35:27PM +0100, Erik Slagter wrote:
> I case this (still) isn't clear, I am addressing the attitude of "It's
> ACPI so it's not going to be used, period".

We're not gonna patch support for any braindead firmware interface into
the scsi midlayer (and trust me, there's a shitload more of them than just
acpi).  Now please sod off.

