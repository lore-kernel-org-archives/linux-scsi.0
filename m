From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Mon, 09 Jan 2012 13:18:18 +0100
Message-ID: <4F0ADB0A.9020707@suse.de>
References: <4EF2026F.2090506@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM> <20111222155849.GD1388@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2AIMSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2012 07:18:20 -0500
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: vgoyal@redhat.com, rwheeler@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On 12/22/2011 09:54 PM, Shyam_Iyer@Dell.com wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Vivek Goyal
>> Sent: Thursday, December 22, 2011 10:59 AM
>> To: Iyer, Shyam
>> Cc: rwheeler@redhat.com; linux-fsdevel@vger.kernel.org; linux-
>> scsi@vger.kernel.org
>> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what=
's
>> missing?
>>
>> On Thu, Dec 22, 2011 at 01:44:16PM +0530, Shyam_Iyer@Dell.com wrote:
>>
>> [..]
>>
>>> Simple asks -
>>> 1) Provide a consistent storage and fs management library that
>> discourages folks to write their own usespace storage library. Inclu=
de
>> things like fs formatting(fs profiles), transport configuration(eg:
>> iscsiadm as a library), thin provisioning watermarks, cluster
>> management, apis for cgroups etc.
>>                                       ^^^^^^^^^^^^^^^^
>> For cgroups, we have libcgroup library. Not many people like to use =
it
>> though as cgroup is exported as a filesystem and they prefer to use
>> normal
>> libc api to traverse and configure cgroups (Instead of going through
>> another library). Some examples include libvrit, systemd.
>>
>> Thanks
>> Vivek
>=20
> Well honestly I think that is a libvirt/systemd issue and libvirt als=
o
> invokes things like iscsiadm, dcb etc as a binary :-/
>=20
> Some one could always use qemu command lines to invoke KVM/XEN but
> libvirt has saved me one too many days in doing a quick operation
> without wondering about a qemu commandline.
> =20
> I am also asking for ideas on how to avoid this fragmentation because
> just like libvirt others are also encouraged to do their own libc
thing
> in the absence of a common storage management framework..
>=20
> Does the standard interface for linux end at the user/kernel boundary
> or the user/libc boundary? If so I feel we would continue to lag
behind
> other OSes in features because of the model.
>=20
StorageAPI _again_.

I was under the impression RH had someone working on it.
(Actually I was trying to give it a go, but then got buried under
customer escalations).

So yes, we know there is a shortcoming.
And yes, we should improve things.

But I feel another discussion about this will only give us more
insight, but not moving things forward.

What about having a separate session at the storage summit (or even
at the collab summit) to hammer out the requirements here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
