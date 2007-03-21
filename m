From: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.21-rc4-git] SCSI newstyle hotplug/coldplug support
Date: Wed, 21 Mar 2007 10:13:34 -0700
Message-ID: <200703211013.35183.david-b@pacbell.net>
References: <200703201736.09280.david-b@pacbell.net> <46011075.6050608@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932857AbXCUQNp@vger.kernel.org>
In-Reply-To: <46011075.6050608@tls.msk.ru>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 21 March 2007 4:01 am, Michael Tokarev wrote:
> David Brownell wrote:
> > This teaches scsi devices how to support "new style" hotplug/coldplug:
> > using a modalias sysfs attribute for coldplug, and MODALIAS environment
> > variable for hotplug.
> 
> How this is different from http://marc.info/?t=115204542200002&r=1&w=2 and
> earlier attempts to do the same?

Not very; I didn't know about previous work.
Why hasn't such support been merged yet?

- Dave
