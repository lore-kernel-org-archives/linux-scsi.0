From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Tue, 25 Sep 2007 21:38:27 -0600
Message-ID: <20070926033827.GB3899@parisc-linux.org>
References: <1190768402.8707.20.camel@localhost.localdomain> <20070925065233Q.tomof@acm.org> <1190770955.8707.23.camel@localhost.localdomain> <20070925073735U.tomof@acm.org> <46F9C5ED.6050505@garzik.org> <20070926025608.GA3899@parisc-linux.org> <46F9D328.4030801@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760896AbXIZDin@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46F9D328.4030801@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 25, 2007 at 11:34:00PM -0400, Jeff Garzik wrote:
> Well, sure, the driver is the owner of that memory.
> 
> We're talking about common code.
> 
> If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.

Oh ... harder to find, but scsi_module.c does that, as does
scsi_register/scsi_unregister.  OK, those are legacy, but they still
exist today.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
