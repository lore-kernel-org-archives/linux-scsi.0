From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: Sat, 22 Jun 2002 19:48:26 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206221943320.8911-100000@serv>
References: <3D14B2CF.90002@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D14B2CF.90002@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Nick Bellinger <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On Sat, 22 Jun 2002, David Brownell wrote:

> Why shouldn't there be a $DRIVERFS/net/ipv4@10.42.135.99/... style hookup
> for iSCSI devices?  Using whatever physical addressing the kernel uses
> there, which I assume wouldn't necessarily be restricted to ipv4.

iSCSI devices are uniqely identified by its name. An iSCSI device can be
reachable at multiple ip numbers or they can even change dynamically.

bye, Roman

