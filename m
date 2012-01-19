From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what'smissing?
Date: Thu, 19 Jan 2012 11:19:40 -0500
Message-ID: <4F18429C.3020803@redhat.com>
References: <4EF2026F.2090506@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM> <20111222155849.GD1388@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM> <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain> <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab2ASQTr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 11:19:47 -0500
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Tom Coughlan <coughlan@redhat.com>, Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On 01/19/2012 11:17 AM, Loke, Chetan wrote:
>> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Tom Coughlan
>
>> Yes, Red Hat does. Tony Asleson. libStorageMgmt:
>>
>> http://sourceforge.net/apps/trac/libstoragemgmt
>>
>> The current focus is on managing external storage (SMI-S, etc.). This
>> focus can be expanded over time. Contributions welcome.
>>
> Device management(scalability/feature mgmt) -
>
> 1) scalability:
> I may be wrong but storage boxes like symmetrix(and others) support
> large number of LUNs.
> So device management 'scalability' will make linux shine. By scalability
> I mean efficiently managing let's say 32K(?) LUNs.

You can actually have (even more) luns than that for each array in a SAN. From a 
host, you will probably not see all of the luns all of the time, but you 
certainly need to have good support for a large lun address space that will be 
sparsely populated.


>
> 2) feature management:
> As Shyam mentioned in earlier emails - provide an ecosystem similar to
> smart-phones. Let me provide an example(and then
> you guys can correct me by saying this already exists or bits and pieces
> exist):
>
> a) As a kernel developer - export all the features(to the upper layers)
> we can by querying the target.
>
> b) As an app developer - GetLUNFeatures(), could return - {Thin
> Provision, RAID-level, ... ).
>
> c) As a sys-admin - If I right click(for a volume/LUN) on my management
> GUI, I should be able to tell if my volume supports thin-prov, backed by
> DRBD[proxy?] etc.
>
> So once we provide b) from above, tens(if not hundreds) of apps will be
> developed in a short period of time.
> I feel libstoragemgmt is an excellent place to get all of this
> organized.
>
>
> Chetan Loke

