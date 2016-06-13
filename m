From: Christoph Hellwig <hch@infradead.org>
Subject: Re: kernel BUG in drivers/scsi/53c700.c:1129
Date: Mon, 13 Jun 2016 01:09:52 -0700
Message-ID: <20160613080952.GB10214@infradead.org>
References: <5759C524.2030009@gmx.de>
 <1465511002.2259.19.camel@HansenPartnership.com>
 <575B2239.4020403@gmx.de>
 <1465592285.20724.173.camel@localhost.localdomain>
 <1465592473.2224.52.camel@HansenPartnership.com>
 <1465594421.2224.58.camel@HansenPartnership.com>
 <1465595032.2224.59.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465595032.2224.59.camel@HansenPartnership.com>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: emilne@redhat.com, Helge Deller <deller@gmx.de>, "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 10, 2016 at 02:43:52PM -0700, James Bottomley wrote:
> OK, I checked: snic and fnic use SCSI_NO_TAG but they don't save
> anything in current_cmnd, so they can't rely on the original behaviour.
>  I think we'll be safe with a local change in 53c700.c

Please move the current_cmnd field in struct scsi_device into the 53c700
driver while you're at it, so that others don't accidentally rely on it.
