From: Pavel Machek <pavel@ucw.cz>
Subject: Re: driverfs is not for everything! (was:  [PATCH] /proc/scsi/map )
Date: Mon, 1 Jul 2002 04:41:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020701024147.GF829@elf.ucw.cz>
References: <59885C5E3098D511AD690002A5072D3C02AB7F53@orsmsx111.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59885C5E3098D511AD690002A5072D3C02AB7F53@orsmsx111.jf.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Grover, Andrew" <andrew.grover@intel.com>
Cc: 'David Brownell' <david-b@pacbell.net>, 'Nick Bellinger' <nickb@attheoffice.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

Hi!

> If a device can be accessed by multiple machines concurrently, it should not
> be in driverfs.

You can access scsi disk from 2 machines simultaneously. Its just not
a common case. I believe we still want scsi in driverfs ;-).
									Pavel
-- 
(about SSSCA) "I don't say this lightly.  However, I really think that the U.S.
no longer is classifiable as a democracy, but rather as a plutocracy." --hpa
