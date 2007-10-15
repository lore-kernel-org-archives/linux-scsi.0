From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 19:56:28 +0100
Message-ID: <20071015185627.GA7236@srcf.ucam.org>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net> <20071015070022.4a0c5957@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763749AbXJOS5X@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071015070022.4a0c5957@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rob Landley <rob@landley.net>, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2007 at 07:00:22AM -0700, Arjan van de Ven wrote:

> that's a choice Ubuntu made in their udev scripts... if you don't like
> it, complain to them.

Keeping the naming as hda while changing the semantics (such as the 
reduced number of partitions) would have been differently confusing. We 
did look into keeping compatibility symlinks, but decided to just 
transition everything to UUIDs instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
