From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Date: Sun, 10 Aug 2008 00:13:25 +0200
Message-ID: <20080810001325.383a9ade@neptune.home>
References: <20080809225153.2fdb23a8@neptune.home>
	<200808100000.25402.rjw@sisk.pl>
	<20080809220154.GO28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp-111-251.adsl.restena.lu ([158.64.111.251]:47044 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752634AbYHIWN2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Aug 2008 18:13:28 -0400
In-Reply-To: <20080809220154.GO28946@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sat, 09 August 2008 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Sun, Aug 10, 2008 at 12:00:24AM +0200, Rafael J. Wysocki wrote:
> > On Saturday, 9 of August 2008, Bruno Pr?mont wrote:
> > > Hi,
> > 
> > Hi,
> > 
> > > Trying out 2.6.27-rc2-git4 on a VIA Ester + CX700 based system I
> > > experience the following panic using a config obtained with make
> > > oldconfig from working 2.6.26 config.
> > > 
> > > Looking at the traces and when it happens it looks like it could
> > > be libATA or SCSI related...
> > > 
> > > 
> > > Note: the kernel is patched with viafb patches sent yesterday
> > > ([y]) and squashfs (<m>)
> > 
> > Could you retest without these two, please?
> 
> There'a another fun candidate: lazy allocation of fpu state.  Do you
> have padlock-aes/padlock-sha/via-rng in use?
> 
They are compiled into the kernel and initialize with 2.6.26.2, though
I have no idea if the kernel uses them more than that...

The crash happens long enough before userspace gets started, as such
except kernel-side users there should be no users of them.

I will check tomorrow without these to determine which one might be the
offending one:
- no crypto,padlock/viarng
- no viafb
- no squashfs (though it should be pretty inoffensive)

Bruno
