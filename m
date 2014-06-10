From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: debug_flag added to st tape driver
Date: Tue, 10 Jun 2014 22:20:30 +0100
Message-ID: <20140610212029.GA30598@localhost.localdomain>
References: <CAAzz28jMu0VeQHZNHWD0jM3YREZrPERnPvTxONStyaV7foFc_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbaFJVql (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 17:46:41 -0400
Content-Disposition: inline
In-Reply-To: <CAAzz28jMu0VeQHZNHWD0jM3YREZrPERnPvTxONStyaV7foFc_Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jun 10, 2014 at 04:57:06PM -0400, Laurence Oberman wrote:
> I am tired of building modules to enable SCSI tape driver debug so I
> am hoping this patch is acceptable.
> Tested using kernel 3.14.6
> 
> Usage example:
> modprobe st debug_flag=1

Missing Signed-off-by :-)
 
> +module_param_named(debug_flag, debug_flag, int, 0);

It's probably not worth making this a sysfs knob as most distros
still compile st as a module although why not just set debugging
directly from the module parameter?

> +MODULE_PARM_DESC(debug_flag, "Enable DEBUG, same as setting DEBUG 1
> in source");
> +

The description is a bit misleading as a bunch of stuff gets
compiled out when DEBUG is unset at compile time.

Maybe "same as setting debugging=1" instead?

