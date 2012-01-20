From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Fri, 20 Jan 2012 09:55:52 +0100
Message-ID: <4F192C18.4060603@suse.de>
References: <4EF2026F.2090506@redhat.com>  <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM>  <20111222155849.GD1388@redhat.com>  <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM>  <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain> <4F0BE06E.5000808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab2ATIz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2012 03:55:56 -0500
In-Reply-To: <4F0BE06E.5000808@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Tom Coughlan <coughlan@redhat.com>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On 01/10/2012 07:53 AM, Ric Wheeler wrote:
> On 01/09/2012 02:59 PM, Tom Coughlan wrote:
>> On Mon, 2012-01-09 at 13:18 +0100, Hannes Reinecke wrote:
>>> On 12/22/2011 09:54 PM, Shyam_Iyer@Dell.com wrote:
>>>>
>>>>> -----Original Message-----
>>>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>>>> owner@vger.kernel.org] On Behalf Of Vivek Goyal
>>>>> Sent: Thursday, December 22, 2011 10:59 AM
>>>>> To: Iyer, Shyam
>>>>> Cc: rwheeler@redhat.com; linux-fsdevel@vger.kernel.org; linux-
>>>>> scsi@vger.kernel.org
>>>>> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server -
>>>>> what's
>>>>> missing?
>>>>>
>>>>> On Thu, Dec 22, 2011 at 01:44:16PM +0530, Shyam_Iyer@Dell.com
>>>>> wrote:
>>>>>
>>>>> [..]
>>>>>
>>>>>> Simple asks -
>>>>>> 1) Provide a consistent storage and fs management library that
>>>>> discourages folks to write their own usespace storage library.
>>>>> Include
>>>>> things like fs formatting(fs profiles), transport
>>>>> configuration(eg:
>>>>> iscsiadm as a library), thin provisioning watermarks, cluster
>>>>> management, apis for cgroups etc.
>>>>>                                        ^^^^^^^^^^^^^^^^
>>>>> For cgroups, we have libcgroup library. Not many people like to
>>>>> use it
>>>>> though as cgroup is exported as a filesystem and they prefer to
>>>>> use
>>>>> normal
>>>>> libc api to traverse and configure cgroups (Instead of going
>>>>> through
>>>>> another library). Some examples include libvrit, systemd.
>>>>>
>>>>> Thanks
>>>>> Vivek
>>>> Well honestly I think that is a libvirt/systemd issue and
>>>> libvirt also
>>>> invokes things like iscsiadm, dcb etc as a binary :-/
>>>>
>>>> Some one could always use qemu command lines to invoke KVM/XEN but
>>>> libvirt has saved me one too many days in doing a quick operation
>>>> without wondering about a qemu commandline.
>>>>
>>>> I am also asking for ideas on how to avoid this fragmentation
>>>> because
>>>> just like libvirt others are also encouraged to do their own libc
>>> thing
>>>> in the absence of a common storage management framework..
>>>>
>>>> Does the standard interface for linux end at the user/kernel
>>>> boundary
>>>> or the user/libc boundary? If so I feel we would continue to lag
>>> behind
>>>> other OSes in features because of the model.
>>>>
>>> StorageAPI _again_.
>>>
>>> I was under the impression RH had someone working on it.
>> Yes, Red Hat does. Tony Asleson. libStorageMgmt:
>>
>> http://sourceforge.net/apps/trac/libstoragemgmt
>>
>> The current focus is on managing external storage (SMI-S, etc.). Thi=
s
>> focus can be expanded over time. Contributions welcome.
>>
>>> (Actually I was trying to give it a go, but then got buried under
>>> customer escalations).
>>>
>>> So yes, we know there is a shortcoming.
>>> And yes, we should improve things.
>>>
>>> But I feel another discussion about this will only give us more
>>> insight, but not moving things forward.
>>>
>>> What about having a separate session at the storage summit (or even
>>> at the collab summit) to hammer out the requirements here?
>> That would be fine, although as you say, we need more than talk.
>>
>> Tom
>>
>=20
> Having a special session would be really a good idea - given the
> size of the discussion, we might want to do both a talk and a
> breakout at collab summit...
>=20
To advance this further, I've submitted a BoF proposal 'Storage
Management on Linux' for the Collab Summit.

I would be available for a joint talk as an introduction if someone
would be interested ...

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
