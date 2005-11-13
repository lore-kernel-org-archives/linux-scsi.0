From: Graham Knap <graham.knap@rogers.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 13 Nov 2005 13:03:57 -0500 (EST)
Message-ID: <20051113180358.35896.qmail@web88004.mail.re2.yahoo.com>
References: <43777ACC.8070503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web88004.mail.re2.yahoo.com ([206.190.37.191]:19292 "HELO
	web88004.mail.re2.yahoo.com") by vger.kernel.org with SMTP
	id S1750935AbVKMSD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 13:03:59 -0500
In-Reply-To: <43777ACC.8070503@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

Doug Ledford <dledford@redhat.com> wrote:
> If the drive is unaccessible after the DV failure, even on a warm
> reboot (which includes a SCSI bus reset), then the drive is flat
> hung. Something done in the current code is breaking it. 

Ah. I had wondered if that was possible.

> Can you get a boot with DV turned off and capture the log messages
> and post them here please? 

I certainly can, but...

> You already said it didn't help with the problem, 

I meant that I don't think I successfully disabled DV, because the boot
messages were *identical*, except for the line where the kernel shows
the "Kernel command line".

I had added this argument at the end of the line:  aic7xxx=dv:{0}

I've re-read "aic7xxx.txt" and I'm not sure what I'm doing wrong. If
you can tell me how to disable DV, I'd be happy to give it a try.

-- graham

