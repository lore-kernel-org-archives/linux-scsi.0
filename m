From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Thu, 30 Aug 2007 20:43:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708302042260.24730@fbirervta.pbzchgretzou.qr>
References: <200708252257.07241.vda.linux@googlemail.com>
 <200708281256.35162.vda.linux@googlemail.com> <20070828081710.4687185c@laptopd505.fenrus.org>
 <200708282055.07411.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58278 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761772AbXH3SnZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 14:43:25 -0400
In-Reply-To: <200708282055.07411.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de


On Aug 28 2007 20:55, Denys Vlasenko wrote:
>> Fwiw I do like your debloat patch a lot; it's just only half the
>> equation ... if you also do the namespace fixes, I bet the driver
>> debloats even more...
>
>Yes, I know, and I am happy to do that too. I just don't know
>whether patches will be accepted.
>
>Why this patch is not commented on by scsi people?
>Am I sending patches to wrong people/lists?

Well, you can send it to Linus/Andrew, that will usually upset people and they
start commenting on it. Or they don't, and everything is fine.
(The "default y" approach so to speak ;-)


	Jan
-- 
