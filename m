From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Thu, 9 Sep 2010 08:50:33 +0200
Message-ID: <20100909085033.78eb4f64@basil.nowhere.org>
References: <4C72D310.4040004@suse.cz>
	<4C7B924D.6030703@panasas.com>
	<201009071712.54867.konrad@darnok.org>
	<4C86B1A4.8030308@oracle.com>
	<4C86B320.8090709@oracle.com>
	<4C86B860.1070105@suse.cz>
	<20100908080557.511d307b@basil.nowhere.org>
	<1283959823.29920.172.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41183 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0IIGui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2010 02:50:38 -0400
In-Reply-To: <1283959823.29920.172.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, fischer@linux-buechse.de, linux-scsi@vger.kernel.org


> OK ... let's try it.  Ji=C5=99=C3=AD send a patch ... and if it break=
s I'm
> handing you the pieces ...

You mean reenable it? Why? Do you have any indication the user base
of this thing (especially on 64bit) is > 0?=20

-Andi

--=20
ak@linux.intel.com -- Speaking for myself only.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
