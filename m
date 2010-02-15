From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC]: new LSI MegaRAID driver implementation
Date: Mon, 15 Feb 2010 13:18:23 -0500
Message-ID: <20100215181823.GA25776@infradead.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7B7668C0E@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7B7668C0E@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 15, 2010 at 10:09:23AM -0700, Mukker, Atul wrote:
> We are anticipating about 70-80% of the current driver code to be changed. These changes would not be functional in nature though. The current functionality would be re-aligned in supporting functions. A parallel stream of functions would be created to support new HBAs.
> 
> We are not anticipating changes in ways the new driver would work with the current generation of the HBAs and therefore we do not foresee any impact on the current functionality for these HBAs.
> 
> We would like to solicit community feedback if this approach is acceptable. Alternative would be to leave the current driver untouched and submit a new driver for next generation of HBAs.
> 
> Your inputs would be highly appreciated.

Please just add a new megaraid_<foo> driver, similar to how megaraid_sas
is split from the legacy megaraid driver.  If the shared code is easy
enough to factor it could be moved into a megaraid_common module, but
in doubt I would not even bother with that.
