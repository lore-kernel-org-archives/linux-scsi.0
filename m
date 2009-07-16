From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: deterministic scsi order with async scan
Date: Thu, 16 Jul 2009 14:05:49 -0600
Message-ID: <20090716200549.GU24310@parisc-linux.org>
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard> <4A5F723B.7070408@emulex.com> <alpine.DEB.1.10.0907161143010.9159@asgard> <1247773155.6606.265.camel@mulgrave.site> <alpine.DEB.1.10.0907161245470.9159@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933246AbZGPUFy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907161245470.9159@asgard>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <James.Smart@Emulex.Com>, Boaz Harrosh <bharrosh@panasas.com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 16, 2009 at 12:48:06PM -0700, david@lang.hm wrote:
> so if I don't use udev but do want the async detection my only option to  
> have it boot from card 1 instead of card 2 is to just keep rebooting the  
> machine until it guesses right?

you could make the driver for card2 a module ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
