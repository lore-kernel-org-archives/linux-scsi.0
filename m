From: Martin Drab <drab@kepler.fjfi.cvut.cz>
Subject: RE: [PATCH] 2.6 aacraid: Fix for controller load based timeouts
Date: Fri, 8 Jul 2005 20:22:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0507082019170.14785@kepler.fjfi.cvut.cz>
References: <60807403EABEB443939A5A7AA8A7458B01642D18@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:33165 "EHLO
	kepler.fjfi.cvut.cz") by vger.kernel.org with ESMTP id S262757AbVGHSWq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2005 14:22:46 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01642D18@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: ryan@autoweb.net, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>



On Fri, 8 Jul 2005, Salyzyn, Mark wrote:
...
> Sadly, anything that goes wrong (including card, power supply, drives)
> can cause containers to go offline; it is a pretty generic symptom to a
> multitude of possible problems. Martin's initial problems were
> associated with using the WD JD drives, which are not compatible with
> RAID cards because their internal error recovery paths.

Yes, however a single WD SD drive didn't make it either, and that _should_ 
be a RAID compatible drive. (Perhaps not with _this_ RAID or I don't 
know.)

Martin

