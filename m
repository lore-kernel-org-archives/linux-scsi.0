From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Thu, 13 Mar 2008 14:34:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803131433100.5744-100000@iolanthe.rowland.org>
References: <20080313091848X.tomof@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080313091848X.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, 13 Mar 2008, FUJITA Tomonori wrote:

> On Thu, 13 Mar 2008 09:03:26 +0900
> FUJITA Tomonori <tomof@acm.org> wrote:
> 
> > > There are two problems.  One is the types of the arguments and return 
> > > value.
> > 
> > They should be ok with the updated patch.
> > 
> > 
> > > The other is that local interrupts need to be disabled.
> > 
> > Can you disable local interrupts here?
> 
> I meant, are you fine with disabling local interrupts here?
> 
> If you don't like that, we need to add another argument and seveal
> 'if' to sg_copy_buffer. But I prefer to keep it simple.

Disabling local interrupts in usb_stor_access_xfer_buf() is okay.

Alan Stern

