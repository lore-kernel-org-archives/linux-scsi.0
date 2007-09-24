From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 24 Sep 2007 12:16:31 +0200
Message-ID: <46F78E7F.3040809@suse.de>
References: <200708311613.59666.vda.linux@googlemail.com> <200708311615.54991.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:40652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbXIXKQd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2007 06:16:33 -0400
In-Reply-To: <200708311615.54991.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Friday 31 August 2007 16:13, Denys Vlasenko wrote:
>> Attached are three patches which fix that:
>>
>>    text    data     bss     dec     hex filename
>>  261433   50018    1172  312623   4c52f linux-2.6.23-rc1.org.t/drive=
rs/scsi/aic7xxx/built-in.o
>>  199654   50018    1172  250844   3d3dc linux-2.6.23-rc1.aic.t/drive=
rs/scsi/aic7xxx/built-in.o
>>  184014   21314    1172  206500   326a4 linux-2.6.23-rc1.aic1.t/driv=
ers/scsi/aic7xxx/built-in.o
>>  202378    2850    1172  206400   32640 linux-2.6.23-rc1.aic2.t/driv=
ers/scsi/aic7xxx/built-in.o
>>
>> 1-debloat.patch    deinlines a lot of functions
>> 2-addstatic.patch  adds statics, #ifdefs out huge amount of unused c=
ode, adds consts
>> 3-addconst.patch   adds more consts
> --
> vda
>=20
>=20
Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
