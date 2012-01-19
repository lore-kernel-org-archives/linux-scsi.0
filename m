From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what'smissing?
Date: Thu, 19 Jan 2012 11:29:36 -0500
Message-ID: <4F1844F0.1030406@redhat.com>
References: <4EF2026F.2090506@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM> <20111222155849.GD1388@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM> <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain> <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com> <4F18429C.3020803@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159134EF@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B9159134EF@nsmail.netscout.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Tom Coughlan <coughlan@redhat.com>, Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/19/2012 11:26 AM, Loke, Chetan wrote:
>> -----Original Message-----
>> From: Ric Wheeler [mailto:rwheeler@redhat.com]
>> Sent: January 19, 2012 11:20 AM
>> To: Loke, Chetan
>> Cc: Tom Coughlan; Hannes Reinecke; tasleson@redhat.com;
>> Shyam_Iyer@Dell.com; vgoyal@redhat.com; linux-fsdevel@vger.kernel.org;
>> linux-scsi@vger.kernel.org
>> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server -
>> what'smissing?
>>
>> On 01/19/2012 11:17 AM, Loke, Chetan wrote:
>>>> From: linux-scsi-owner@vger.kernel.org
>>> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Tom Coughlan
>>>
>>>> Yes, Red Hat does. Tony Asleson. libStorageMgmt:
>>>>
>>>> http://sourceforge.net/apps/trac/libstoragemgmt
>>>>
>>>> The current focus is on managing external storage (SMI-S, etc.).
>> This
>>>> focus can be expanded over time. Contributions welcome.
>>>>
>>> Device management(scalability/feature mgmt) -
>>>
>>> 1) scalability:
>>> I may be wrong but storage boxes like symmetrix(and others) support
>>> large number of LUNs.
>>> So device management 'scalability' will make linux shine. By
>> scalability
>>> I mean efficiently managing let's say 32K(?) LUNs.
>> You can actually have (even more) luns than that for each array in a
>> SAN. From a host, you will probably not see all of the luns all of the
> time, but
>> you certainly need to have good support for a large lun address space
> that
>> will be sparsely populated.
>>
>>
> True, a single front-end won't see all of those LUNs/devices. So not a
> big concern
> about the front-end hosts.
>
> I am thinking of a use-case where folks can use a linux-box to manage
> their different storage arrays.
> So this linux box with 'libstoragemgmt + app' needs to
> manage(scan/create/delete/so on) all those LUNs.
>
>
> Chetan Loke

People do have boxes with thousands of luns though & file systems in active use. 
Both for SAN and NAS volumes.

One of the challenges is what to do when just one LUN (or NFS server) crashes 
and burns. You simply cannot "reboot" the server to clean up after one bad mount 
when you have thousands of other happy users runs on thousands/hundreds of other 
mount points :)

Ric

