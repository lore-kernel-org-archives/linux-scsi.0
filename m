From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: ultrastor.c is a bit-rot
Date: Sun, 23 Mar 2008 11:54:39 +0200
Message-ID: <47E628DF.6070301@panasas.com>
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org> <47E41D7D.9050409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758899AbYCWJzR@vger.kernel.org>
In-Reply-To: <47E41D7D.9050409@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 21 2008 at 22:41 +0200, "H. Peter Anvin" <hpa@zytor.com> wrote:
> Matthew Wilcox wrote:
>> VESA Local Bus.  It was (in some sense) the predecessor of AGP.  We
>> treat it like ISA inside the kernel.  On x86, EISA depends on ISA, so
>> the dependency, while wrong, does not affect any x86 users who have an
>> EISA card.
>>
> 
> Well, one can say VLB was to ISA (a souped-up ISA bus with some of the 
> worst limitations removed) what AGP is to PCI...
> 
> 	-hpa

Hmm interesting, so someone took the VGA thing and made a storage device
for it. Did that ever happen with AGP? Any AGP scsi cards. I guess I can
Google for it.

Boaz
