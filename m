From: Simon Burley <simonb@lipsyncpost.co.uk>
Subject: Re: SCSI related kernel errors with 2.4
Date: Tue, 25 Feb 2003 11:12:38 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E5B4FA6.86BCA343@lipsyncpost.co.uk>
References: <20030224204753.13977.qmail@solo.americom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: jeff@AmeriCom.com
Cc: linux-scsi@vger.kernel.org

jeff@AmeriCom.com wrote:
> 
> We've been having crashes we think are related to the scsi driver, I have found other
> people with the same problem by doing google searches. It happens to people burning
> CD's, doing tape backups, and sometimes during normal operation. We never experienced
> this problem with the 2.2 kernel. We tried updating the scsi driver to the latest
> (6.2.28) and the only thing that changed is the error output is a little more
> verbose. The tape drive and the hard drive are both on the same SCSI bus, let me know
> and I can post full hardware specs. It seems when the machine is dead that the hard
> disk is unaccessable, but I can ping the machine and do simple non-disk-accessing
> tasks, its as if the scsi hard disk is offline.
> 
> Is anybody aware of this bug? Should I bare with it for a while, or downgrade to 2.2?

<snipped>

Jeffrey,
I went through exactly the same thing about a year ago with a kernel
upgrade on one of my machines. You havn't said which Adaptec you're
using, but this setup was a 2940UW with one internal drive and one
external drive.
I can't explain this, but after ripping the box apart and checking
termination on the internal drive, I found that it wasn't set. Setting
it fixed the problem, as did reverting to a 2.2 kernel.

Hope that helps a little. Sorry if it seems I'm teaching granny to suck
eggs.
Simon
