From: "Grover, Andrew" <andrew.grover@intel.com>
Subject: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map)
Date: Sun, 23 Jun 2002 15:59:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <59885C5E3098D511AD690002A5072D3C02AB7F52@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Nick Bellinger' <nickb@attheoffice.org>, David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

> From: Nick Bellinger [mailto:nickb@attheoffice.org] 
> Giving the IP stack its own directory (leaf?) under driverfs 
> root sounds
> interesting enough and could have some potential uses, but in the case
> of iSCSI there are a few problems:

I know this is one of those things that has more and more cool possibilities
the more you think about it but...

Is the device PHYSICALLY hooked up to the computer? If not, it shouldn't be
in devicefs.

The device tree (for which devicefs is the fs representation) was originally
meant to enable good device power management and configuration. driverfs
wasn't meant to handle iscsi or tcpip (that is, network) connections, nor
should it have to.

Regards -- Andy
