From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Mon, 16 Jan 2017 10:04:46 -0800
Message-ID: <20170116180446.GA28023@infradead.org>
References: <1484319727.2527.8.camel@HansenPartnership.com>
 <20170115091925.GA26656@gmail.com>
 <1484496665.2405.2.camel@HansenPartnership.com>
 <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com>
 <1484507599.2405.16.camel@HansenPartnership.com>
 <CA+55aFyyBf9SLSNDRqMcFbmUBBkbamZYXGOgfXU8k5KYaFD2mw@mail.gmail.com>
 <1484509776.2405.21.camel@HansenPartnership.com>
 <1484517756.11850.1.camel@sandisk.com>
 <20170116152721.GA6677@infradead.org>
 <1484583279.2540.37.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484583279.2540.37.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 16, 2017 at 08:14:39AM -0800, James Bottomley wrote:
> So how about, instead of arguing about reversion, one or other of you
> reviews the proposed fix of the fix which would avoid having to revert
> anything?

As far as I can tell everyone is waiting for you to resend it with the
review comment from the Broadcom maintainers adddressed.
