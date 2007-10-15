From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 12:00:50 -0600
Message-ID: <20071015180050.GB25488@parisc-linux.org>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net> <20071015172513.GA5738@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752896AbXJOSBd@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071015172513.GA5738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2007 at 10:25:13AM -0700, Greg KH wrote:
> Use mount-by-label instead, it's much saner and handles device name
> movement just fine (as does the UUID method that you seem to hate.)
> Look in /dev/disk/ for a wide range of options that you have in which to
> choose how to pick your block devices.

But you still have to spin up the disc to read the label (which seems
like a legitimate complaint to me).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
