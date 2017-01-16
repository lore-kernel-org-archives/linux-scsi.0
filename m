From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Mon, 16 Jan 2017 08:14:39 -0800
Message-ID: <1484583279.2540.37.camel@HansenPartnership.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
         <20170115091925.GA26656@gmail.com>
         <1484496665.2405.2.camel@HansenPartnership.com>
         <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com>
         <1484507599.2405.16.camel@HansenPartnership.com>
         <CA+55aFyyBf9SLSNDRqMcFbmUBBkbamZYXGOgfXU8k5KYaFD2mw@mail.gmail.com>
         <1484509776.2405.21.camel@HansenPartnership.com>
         <1484517756.11850.1.camel@sandisk.com>
         <20170116152721.GA6677@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170116152721.GA6677@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-01-16 at 07:27 -0800, Christoph Hellwig wrote:
> On Sun, Jan 15, 2017 at 10:02:51PM +0000, Bart Van Assche wrote:
> > I disagree. Even if my patch would be reverted that still wouldn't 
> > fix the severe race condition that was introduced in the mpt3sas 
> > driver by the patch that triggers the lockup during boot. As I 
> > explained two weeks ago (see also 
> > https://www.spinics.net/lists/kernel/msg2411413.htm
> > l), commit 18f6084a989b ("scsi: mpt3sas: Fix secure erase premature
> > termination") is the one that should be reverted instead of my 
> > patch. I agree with Linus that the offending mpt3sas patch already 
> > should have been reverted.
> 
> In addition to that ATA passthrough through scsi CDBs is a fringe
> feature compared to normal operation of the HBA.

So how about, instead of arguing about reversion, one or other of you
reviews the proposed fix of the fix which would avoid having to revert
anything?

James
