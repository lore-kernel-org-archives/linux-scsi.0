From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 12 Feb 2008 11:45:29 -0800 (PST)
Message-ID: <608362.85432.qm@web31812.mail.mud.yahoo.com>
References: <20080212102244.32869382@appleyard>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:30598 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752450AbYBLTpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 14:45:30 -0500
In-Reply-To: <20080212102244.32869382@appleyard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

--- On Tue, 2/12/08, Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> Hi,
> I apologize for taking so long to review this patch.  I
> obviously agree
> wholeheartedly with Luben.  The problem I ran into while
> trying to
> design an enclosure management interface for the SATA
> devices is that
> there is all this vendor defined stuff.  For example, for
> the AHCI LED
> protocol, the only "defined" LED is
> 'activity'.  For LED2 and LED3 it
> is up to hardware vendors to define these.  For SGPIO
> there's all kinds
> of ways for hw vendors to customize.  I felt that it was
> going to be a
> maintainance nightmare to have to keep track of various
> vendors
> enclosure implementations in the ahci driver, and that
> it'd be better
> to just have user space libraries take care of that.  Plus,
> that way a
> vendor doesn't have to get a patch into the kernel to
> get their new
> spiffy wizzy bang blinky lights working (think of how long
> it takes
> something to even get into a vendor kernel, which is what
> these guys
> care about...).  So I'm still not sold on having an
> enclosure
> abstraction in the kernel - at least for the SATA
> controllers.

And I agree wholeheartedly with Kristen.

   Luben

