From: "J. Ryan Earl" <heretic@clanhk.org>
Subject: Re: Serial ATA (SATA) for Linux status report
Date: Tue, 9 Dec 2003 13:59:24 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200312091359.24546.heretic@clanhk.org>
References: <20031203204445.GA26987@gtf.org>
Reply-To: heretic@clanhk.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031203204445.GA26987@gtf.org>
Content-Disposition: inline
To: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 03 December 2003 02:44 pm, Jeff Garzik wrote:
> Queueing support
> 3) "Native Command Queueing" -- both host and drive cooperate in the
> queueing and execution of drive commands.  This should provide the
> highest performance and lowest latency of all three options.

Has anyone gotten their hands on any Silicon Image 3124 hardware?  It was 
announced 3 months ago and supports PCI-X plus it's designed to support 
whatever the final SATA 2.0 spec ends up being.  Full NCQ support.

http://www.siliconimage.com/products/sii3124.asp

> Hotplug support
> ---------------
> All SATA is hotplug.
>
> libata does not support hotplug... yet.

Hot-Plug seems like one of the most universally supported features.  What will 
it take to get it working?  And what will it take to get it working on 2.4?  
Is that a major feature we'll just have to wait for in libata?

I personally need hot-swap on production servers.

-ryan
