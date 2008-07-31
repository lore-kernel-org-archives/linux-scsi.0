From: Martin Samuelsson <sam@home.se>
Subject: Re: aacraid and S.M.A.R.T
Date: Thu, 31 Jul 2008 09:41:31 +0200
Message-ID: <20080731094131.2db49729.sam@home.se>
References: <20080730235450.0fcc21a6.sam@home.se>
	<EC1C30B3-9ED0-4A8B-90FE-F4AB25FF5E7A@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxy3.bredband.net ([195.54.101.73]:63378 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYGaHlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 03:41:35 -0400
Received: from ironport2.bredband.com (195.54.101.122) by proxy3.bredband.net (7.3.127)
        id 481183EA01879E23 for linux-scsi@vger.kernel.org; Thu, 31 Jul 2008 09:41:34 +0200
In-Reply-To: <EC1C30B3-9ED0-4A8B-90FE-F4AB25FF5E7A@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>, AACRAID <aacraid@adaptec.com>

On Wed, 30 Jul 2008 22:06:38 -0400
Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:

> aacraid driver is not the emulation. The Firmware itself has a SAT 0.9  
> translation layer to the raw SATA drives at the physical transport,  
> the Firmware then deals with all the targets as SCSI representations.

Ow, OK, that explains things.

> SMART was supposed to be emulated, but on that old card it was never  
> tested ... make sure you have the latest Firmware on the card just in  
> case something got fixed ...

I will. A slight problem is that the 2610SA is a card that seem to be a Dell exclusive thing, and impossible to find any information about on the Adaptec site. I'll try, and then I'll try at the Dell site, just in case.

Thanks for your help!

Regards,
/Sam
