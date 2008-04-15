From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] debloat aic7xxx and aic79xx drivers
Date: Tue, 15 Apr 2008 16:44:48 +0200
Message-ID: <4804BF60.2070701@suse.de>
References: <200803230440.40685.vda.linux@googlemail.com> <47FB63C2.4030006@suse.de> <200804081608.43248.vda.linux@googlemail.com> <200804142046.31080.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:54925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713AbYDOOot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2008 10:44:49 -0400
In-Reply-To: <200804142046.31080.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-scsi@vger.kernel.org

Hi Denys,

Denys Vlasenko wrote:
> Hi Hannes,
>=20
> On Tuesday 08 April 2008 16:08, Denys Vlasenko wrote:
[ .. ]
>> I do understand this, and I do understnad then _shipped files
>> are generated. But I failed to find out HOW they are generated.
>> I don't want to _only_ patch aicasm/* files and skip checking
>> that my changes work (or at least compile).
>>
>> Please let me know how to regenerate these _shipped files,
>> and I will fix it "correctly" by modifying aicasm/* files.
>=20
> I didn't get any reply. Perhaps you were busy with more important stu=
ff.
>=20
There are such strange creatures named 'customers'. They have a habit
of get into the way ...

But I thought I had answered this already ...
Anyway, you'll have to enable the firmware build for aic7xxx / aic79xx
and do a diff between the files used for compiling and the *_shipped
files.
Then fixup the assembler in aicasm/* to print out the files in the way
you'd like it.
Once you're done you copy the generated files over to the *_shipped
files and send the diff.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
