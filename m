From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/6] ZAC host-aware device support
Date: Mon, 03 Aug 2015 09:24:57 +0200
Message-ID: <55BF1749.8090606@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de> <1438531870.2182.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1438531870.2182.23.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/02/2015 06:11 PM, James Bottomley wrote:
> On Fri, 2015-07-31 at 15:02 +0200, Hannes Reinecke wrote:
>> Hi all,
>>
>> here is a patchset for adding ZAC host-aware device support to libat=
a.
>> Main bits are translations for ZBC IN and ZBC OUT; others are the
>> required plumbing like generating the correct VPD pages.
>> James, do you require a separate patch for adding ZBC IN and ZBC OUT
>> or is it okay to have it queued here?
>=20
> This really belongs in the ZBC patch set, doesn't it? Why isn't it
> there.  You can't avoid the dependency.  If it goes with the ZAC patc=
h
> set, then the ZBC one depends on ZAC.  If it goes properly with ZBC t=
hen
> you need an additional patch adding the ATA translations after the ZB=
C
> one.  On the whole, I'd prefer the latter so we always have the requi=
red
> consumers of the API.
>=20
> In fact, if I read the dependencies correctly, you need the ZBC patch=
es
> first, don't you ... otherwise there's nothing to drive host aware ZA=
C?
>=20
No. These patches just implement a proper SATL for ZAC drives.
So in effect they just bring libata support on par with 'real' ZBC
drives, allowing things like 'sg_rep_zones' to work properly there.

As such I've considered those patches to be a precursor for ZBC support=
=2E

But then, I don't mind how it's being handled.
I surely can turn things around, ZBC support first, and ZAC as an
add-on to that.
Just say the word.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
