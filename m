From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Tue, 10 Jan 2012 08:53:34 +0200
Message-ID: <4F0BE06E.5000808@redhat.com>
References: <4EF2026F.2090506@redhat.com>  <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM>  <20111222155849.GD1388@redhat.com>  <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM>  <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1326113987.2580.8.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tom Coughlan <coughlan@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/09/2012 02:59 PM, Tom Coughlan wrote:
> On Mon, 2012-01-09 at 13:18 +0100, Hannes Reinecke wrote:
>> On 12/22/2011 09:54 PM, Shyam_Iyer@Dell.com wrote:
>>>
>>>> -----Original Message-----
>>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>>> owner@vger.kernel.org] On Behalf Of Vivek Goyal
>>>> Sent: Thursday, December 22, 2011 10:59 AM
>>>> To: Iyer, Shyam
>>>> Cc: rwheeler@redhat.com; linux-fsdevel@vger.kernel.org; linux-
>>>> scsi@vger.kernel.org
>>>> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's
>>>> missing?
>>>>
>>>> On Thu, Dec 22, 2011 at 01:44:16PM +0530, Shyam_Iyer@Dell.com wrote:
>>>>
>>>> [..]
>>>>
>>>>> Simple asks -
>>>>> 1) Provide a consistent storage and fs management library that
>>>> discourages folks to write their own usespace storage library. Include
>>>> things like fs formatting(fs profiles), transport configuration(eg:
>>>> iscsiadm as a library), thin provisioning watermarks, cluster
>>>> management, apis for cgroups etc.
>>>>                                        ^^^^^^^^^^^^^^^^
>>>> For cgroups, we have libcgroup library. Not many people like to use it
>>>> though as cgroup is exported as a filesystem and they prefer to use
>>>> normal
>>>> libc api to traverse and configure cgroups (Instead of going through
>>>> another library). Some examples include libvrit, systemd.
>>>>
>>>> Thanks
>>>> Vivek
>>> Well honestly I think that is a libvirt/systemd issue and libvirt also
>>> invokes things like iscsiadm, dcb etc as a binary :-/
>>>
>>> Some one could always use qemu command lines to invoke KVM/XEN but
>>> libvirt has saved me one too many days in doing a quick operation
>>> without wondering about a qemu commandline.
>>>
>>> I am also asking for ideas on how to avoid this fragmentation because
>>> just like libvirt others are also encouraged to do their own libc
>> thing
>>> in the absence of a common storage management framework..
>>>
>>> Does the standard interface for linux end at the user/kernel boundary
>>> or the user/libc boundary? If so I feel we would continue to lag
>> behind
>>> other OSes in features because of the model.
>>>
>> StorageAPI _again_.
>>
>> I was under the impression RH had someone working on it.
> Yes, Red Hat does. Tony Asleson. libStorageMgmt:
>
> http://sourceforge.net/apps/trac/libstoragemgmt
>
> The current focus is on managing external storage (SMI-S, etc.). This
> focus can be expanded over time. Contributions welcome.
>
>> (Actually I was trying to give it a go, but then got buried under
>> customer escalations).
>>
>> So yes, we know there is a shortcoming.
>> And yes, we should improve things.
>>
>> But I feel another discussion about this will only give us more
>> insight, but not moving things forward.
>>
>> What about having a separate session at the storage summit (or even
>> at the collab summit) to hammer out the requirements here?
> That would be fine, although as you say, we need more than talk.
>
> Tom
>

Having a special session would be really a good idea - given the size of the 
discussion, we might want to do both a talk and a breakout at collab summit...

ric

