From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables
 by GUID
Date: Mon, 21 Mar 2011 15:12:19 -0400
Message-ID: <20110321191219.GA6761@infradead.org>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
 <20110318225016.GB15921@suse.de>
 <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com>
 <20110319002246.GB14249@suse.de>
 <4D8403C3.6020300@intel.com>
 <20110320001459.GA9237@suse.de>
 <1300583607.12679.29.camel@mulgrave.site>
 <4D87A1E6.2000006@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D87A1E6.2000006@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Greg KH <gregkh@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 21, 2011 at 12:07:18PM -0700, Dan Williams wrote:
> Ideally this would have been something that just showed up in an
> option-rom bar on the device, but that did not happen so it is left
> to software.  For legacy-bios we scan adapter rom space looking for
> our table, for efi it's comparatively cleaner we just grab this efi
> variable identified by its own GUID.

In the worse case a late merged icsi driver just wouldn't support
EFI-based boards out ot the box until 2.6.40.  I don't think that
is too much of an issue.
