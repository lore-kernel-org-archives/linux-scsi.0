From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Date: Sun, 1 Apr 2012 18:34:09 +0800
Message-ID: <20120401103408.GA2815@localhost.amd.com>
References: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
 <Pine.LNX.4.44L0.1203291050580.1417-100000@iolanthe.rowland.org>
 <20120330010730.GA27346@ladygaga>
 <4F76E054.8010301@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6482 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056Ab2DACe3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Mar 2012 22:34:29 -0400
Content-Disposition: inline
In-Reply-To: <4F76E054.8010301@computer.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>

On Sat, Mar 31, 2012 at 12:45:40PM +0200, Jan Ceuleers wrote:
> 
> What about slot-loading optical drives, where the user does not
> first have to press a button to open the tray (due to a lack of
> tray)?

For slot type ODD, the insert of a disk will fire the gpe event by
means of the sata slimline connector's device attention pin.

That means, the insert of a disk into a slot type ODD and the
press of the eject button of a tray type ODD has the same effect to
trigger the resume process.

Thanks,
Aaron


