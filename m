From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Fri, 24 Sep 2010 22:55:34 +0300
Message-ID: <4C9D0236.2030803@suse.cz>
References: <4C72D310.4040004@suse.cz>	<4C7B924D.6030703@panasas.com>	<201009071712.54867.konrad@darnok.org>	<4C86B1A4.8030308@oracle.com>	<4C86B320.8090709@oracle.com>	<4C86B860.1070105@suse.cz>	<20100908080557.511d307b@basil.nowhere.org>	<1283959823.29920.172.camel@mulgrave.site> <20100909085033.78eb4f64@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37546 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab0IXTzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2010 15:55:40 -0400
Received: by fxm3 with SMTP id 3so949999fxm.19
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2010 12:55:39 -0700 (PDT)
In-Reply-To: <20100909085033.78eb4f64@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, fischer@linux-buechse.de, linux-scsi@vger.kernel.org

On 09/09/2010 09:50 AM, Andi Kleen wrote:
>> OK ... let's try it.  Ji=C5=99=C3=AD send a patch ... and if it brea=
ks I'm
>> handing you the pieces ...
>=20
> You mean reenable it? Why? Do you have any indication the user base
> of this thing (especially on 64bit) is > 0?=20

Yeah, I know of two people who upgraded to 64-bit recently and had been
using that driver before (the one for scanner). They both report it's
working if non-64bit condition is removed. So I will post a patch to
enable it back again...

regards,
--=20
js
suse labs
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
