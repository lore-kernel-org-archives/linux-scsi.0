From: Steven Cole <elenstev@mesatop.com>
Subject: Re: [PATCH 2.5] fix megaraid driver compile error
Date: 06 Feb 2003 14:00:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044565217.14310.253.camel@spc9.esa.lanl.gov>
References: <Pine.LNX.4.44.0302061202430.3545-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302061202430.3545-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, 2003-02-06 at 13:04, Linus Torvalds wrote:
> 
> On 6 Feb 2003, Mark Haverkamp wrote:
> >
> > This moves access of the host element to device since host has been
> > removed from struct scsi_cmnd.
> 
> This is whitespace-damaged.
> 
> Please fix broken mailers. I generally don't bother to fix up whitespace
> damage from people who can't bother to have a good mailer. It's just not 
> worth it - if I try to fix it up (even if it is often trivial), it just 
> means that people will continue to send crap patches to me.
> 
> 		Linus

In this case the issue is not a broken mailer, but rather the improper
use of a good one.  Mark is using Evolution and so am I.  It appears
that he did a cut and paste from an xterm (or something similar) which
converted the tabs to spaces.

For other Evolution users out there, a better way to send patches with
undamaged whitespace and not line-wrapped is to choose Insert and then
Inline Text File.  This will send a Linus-compatible inlined (not
attached) patch.  

Here is Mark's patch again, sent from Evolution, and not
whitespace-damaged:

Steven

--- linux-2.5.59/drivers/scsi/megaraid.c.orig	Thu Feb  6 13:31:24 2003
+++ linux-2.5.59/drivers/scsi/megaraid.c	Thu Feb  6 13:33:06 2003
@@ -4515,7 +4515,7 @@
 		if(scsicmd == NULL) return -ENOMEM;
 
 		memset(scsicmd, 0, sizeof(Scsi_Cmnd));
-		scsicmd->host = shpnt;
+		scsicmd->device->host = shpnt;
 
 		if( outlen || inlen ) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -4652,7 +4652,7 @@
 		if(scsicmd == NULL) return -ENOMEM;
 
 		memset(scsicmd, 0, sizeof(Scsi_Cmnd));
-		scsicmd->host = shpnt;
+		scsicmd->device->host = shpnt;
 
 		if (outlen || inlen) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)


