From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fix potential return of uninitialized variable in
	scsi_scan   (resend)
Date: Sat, 18 Mar 2006 17:10:33 -0600
Message-ID: <1142723433.3773.16.camel@mulgrave.il.steeleye.com>
References: <200603182242.52507.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751113AbWCRXKo@vger.kernel.org>
In-Reply-To: <200603182242.52507.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2006-03-18 at 22:42 +0100, Jesper Juhl wrote:
> ( The patch below was already send on March 9, 2006. )
> ( This is a resend, re-diff'ed against 2.6.16-rc6    )
> 
> 
> The coverity checker found out that we potentially return sdev uninitialized.
> This should fix coverity #879

The fix for this is already in scsi-misc.

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=a97a83a06b44d4d1cb01191423caf9813a150b95

James
