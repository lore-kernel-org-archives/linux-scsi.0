From: Matthew Wilcox <willy@debian.org>
Subject: Re: iSCSI HBA needs to have a unique host id
Date: Fri, 14 Nov 2003 17:37:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114173742.GG30485@parcelfarce.linux.theplanet.co.uk>
References: <009d01c3aa95$9d613b70$a0074d0a@apac.cisco.com> <1068829950.4781.74.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:61152 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262794AbTKNRhn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:37:43 -0500
Content-Disposition: inline
In-Reply-To: <1068829950.4781.74.camel@persist.az.mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

On Fri, Nov 14, 2003 at 10:12:30AM -0700, Steven Dake wrote:
> I suggest
> examining the uSDE project www.sourceforge.net/projects/usde for an
> example implementation.

I suggest you look at the udev project instead since uSDE is unlikely
to be used by more than a tiny minority of systems.

http://lwn.net/Articles/55176/

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
