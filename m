From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Sat, 10 Dec 2005 02:50:04 +0000
Message-ID: <20051210025004.GB31328@srcf.ucam.org>
References: <20051209114246.GB16945@infradead.org> <20051209114944.GA1068@havoc.gtf.org> <20051209115235.GB25771@srcf.ucam.org> <43997171.9060105@pobox.com> <20051209121124.GA25974@srcf.ucam.org> <439975AB.5000902@pobox.com> <20051209122457.GB26070@srcf.ucam.org> <439A23E8.3080407@pobox.com> <20051210023426.GA31220@srcf.ucam.org> <439A4070.2000500@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932776AbVLJCuf@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <439A4070.2000500@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 09, 2005 at 09:41:52PM -0500, Jeff Garzik wrote:

> Do you even know if this special case is applicable outside of Dell ICH5 
> boxes?  And I thought your previous messages were referring to ICH6?

Every laptop I have access to, whether it's SATA or PATA, fires an ACPI 
notification when a drive is removed from a bay. The ICH5 case is 
probably somewhat special-cased, but when we move over to driving PATA 
with libata it's going to be a lot more useful. If ICH6 can be managed 
without resorting to ACPI, it's less necessary in the short term, but I 
think PATA support is going to require it in the end anyway (especially 
since we probably want to call the _GTM and _STM methods on PATA 
devices)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
