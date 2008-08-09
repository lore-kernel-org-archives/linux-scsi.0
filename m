From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Date: Sat, 9 Aug 2008 23:01:54 +0100
Message-ID: <20080809220154.GO28946@ZenIV.linux.org.uk>
References: <20080809225153.2fdb23a8@neptune.home> <200808100000.25402.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200808100000.25402.rjw@sisk.pl>
Sender: linux-ide-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bruno Pr?mont <bonbons@linux-vserver.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 10, 2008 at 12:00:24AM +0200, Rafael J. Wysocki wrote:
> On Saturday, 9 of August 2008, Bruno Pr?mont wrote:
> > Hi,
> 
> Hi,
> 
> > Trying out 2.6.27-rc2-git4 on a VIA Ester + CX700 based system I
> > experience the following panic using a config obtained with make
> > oldconfig from working 2.6.26 config.
> > 
> > Looking at the traces and when it happens it looks like it could be
> > libATA or SCSI related...
> > 
> > 
> > Note: the kernel is patched with viafb patches sent yesterday ([y]) and
> > squashfs (<m>)
> 
> Could you retest without these two, please?

There'a another fun candidate: lazy allocation of fpu state.  Do you have
padlock-aes/padlock-sha/via-rng in use?
