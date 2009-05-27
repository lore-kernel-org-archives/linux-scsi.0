From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Wed, 27 May 2009 13:35:31 +0200
Message-ID: <4A1D2583.8040803@suse.de>
References: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

Alan Stern wrote:
> On Wed, 27 May 2009, Kay Sievers wrote:
>=20
>> On Wed, May 27, 2009 at 01:49, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>>
>>> OK ... perhaps we have to wait a little harder: try this; it waits =
until
>>> all the targets have disappeared from visibility via an event.
>> That seems to work fine here.
>=20
> It's good for a short-term fix.  For the longer term, I still think=20
> it's a mistake to wait for the sdevs to be released before deleting t=
he=20
> target.  It gives user programs the ability to block the host-removal=
=20
> thread indefinitely.
>=20
Quite so. We should rather see to have the reference counting fixed
properly, than this would go away automatically.

So I just have to look for someone to fix my iSCSI bugs, than I could
revamp my patchset ...

Sigh.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
