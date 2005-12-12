From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Mon, 12 Dec 2005 00:38:28 +0000
Message-ID: <1134347909.2737.10.camel@localhost>
References: <20051208145257.GB21946@srcf.ucam.org>
	 <20051208171901.GA22451@srcf.ucam.org>
	 <20051209114246.GB16945@infradead.org>
	 <20051209114944.GA1068@havoc.gtf.org>
	 <20051209115235.GB25771@srcf.ucam.org> <43997171.9060105@pobox.com>
	 <20051209121124.GA25974@srcf.ucam.org> <439975AB.5000902@pobox.com>
	 <20051209122457.GB26070@srcf.ucam.org> <439A23E8.3080407@pobox.com>
	 <20051210023426.GA31220@srcf.ucam.org>  <439A4070.2000500@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <439A4070.2000500@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Gwe, 2005-12-09 at 21:41 -0500, Jeff Garzik wrote:
> Do you even know if this special case is applicable outside of Dell ICH5 
> boxes?  And I thought your previous messages were referring to ICH6?

Some older thinkpads seem to support this. Also some laptops generate
pnpbios changes. The different methods alone argue for a generic
interface
h
