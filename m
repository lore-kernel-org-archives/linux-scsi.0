From: Atlant Schmidt <aschmidt@dekaresearch.com>
Subject: RE: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 18:29:53 +0000
Message-ID: <ec4494d0b0d348c7a2e90242b67fa5a4@DEKAEXCHANGE13.deka.local>
References: <20170507204007.GA25628@atrey.karlin.mff.cuni.cz>
 <1494228094.6528.14.camel@infradead.org>
 <alpine.DEB.2.11.1705080930150.6882@lnxricardw1>
 <1494231215.6528.22.camel@infradead.org>
 <alpine.DEB.2.11.1705081034420.6882@lnxricardw1>
 <1494233673.6528.28.camel@infradead.org>
 <alpine.DEB.2.11.1705081059580.6882@lnxricardw1>
 <7ee84982-cfad-94d7-4e22-4edbeb852b32@redhat.com>
 <1494238390.6528.42.camel@infradead.org> <20170508135005.0b9b200b@bbrezillon>
 <20170508164322.GA9781@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170508164322.GA9781@amd>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>, Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Ricard Wanderlof <ricard.wanderlof@axis.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org

> Well, you are right.. and I'm responsible.
>
> What I was trying to point out was that storage people try to treat SSDs as HDDs...
> and SSDs are very different. Harddrives mostly survive powerfails (with emergency
> parking), while it is very, very difficult to make SSD survive random powerfail,
> and we have to make sure we always powerdown SSDs "cleanly".

  It all depends on the class of SSD that we're discussing.
  "Enterprise class" SSDs will often use either ultracapacitors
  or batteries to allow them to successfully complete all of
  the necessary operations upon a power cut.

This e-mail and the information, including any attachments it contains, are intended to be a confidential communication only to the person or entity to whom it is addressed and may contain information that is privileged. If the reader of this message is not the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please immediately notify the sender and destroy the original message. Thank you. Please consider the environment before printing this email.
