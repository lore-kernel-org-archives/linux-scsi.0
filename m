From: Hannes Reinecke <hare@suse.de>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
Date: Mon, 20 Jul 2009 14:15:10 +0200
Message-ID: <4A645FCE.5030506@suse.de>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>	 <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com> <1247670563.4236.16.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753551AbZGTMPO@vger.kernel.org>
In-Reply-To: <1247670563.4236.16.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: rohan a <info1686@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-07-15 at 20:33 +0530, rohan a wrote:
>> Hi guys,
>>
>> Any suggestions...please help
>=20
> I know of no kernel bug that could be causing this.  The SLES9 kernel=
 is
> just too old though for me to remember clearly.  I'd suggest you file=
 a
> support incident with SUSE ... they'll debug and fix this on the olde=
r
> kernels; we really only deal with the new kernel and one or two back
> revisions here on linux-scsi.
>=20
You did that on purpose.
The 'they' is actually me :-(

Actually, there already _is_ a bug, so no need to open another one.
Which HBA are you using?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
