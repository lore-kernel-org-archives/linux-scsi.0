From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Tue, 07 Jul 2015 08:29:26 +0200
Message-ID: <559B71C6.3030409@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>	 <20150619064855.GB1183@lst.de> <5583C117.4030103@suse.de>	 <1435048143.7460.50.camel@haakon3.risingtidesystems.com>	 <55892164.6020907@suse.de>	 <1436228703.5138.2.camel@haakon3.risingtidesystems.com>	 <559B6893.5030604@suse.de> <1436250407.23883.25.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436250407.23883.25.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 07/07/2015 08:26 AM, Nicholas A. Bellinger wrote:
> On Tue, 2015-07-07 at 07:50 +0200, Hannes Reinecke wrote:
>> On 07/07/2015 02:25 AM, Nicholas A. Bellinger wrote:
>>> On Tue, 2015-06-23 at 11:05 +0200, Hannes Reinecke wrote:
>>>> On 06/23/2015 10:29 AM, Nicholas A. Bellinger wrote:
>=20
> <SNIP>
>=20
>>>>> How different do you expect sas, fc, and iscsi transports to be..=
?
>>>>>
>>>>> Do you think this would this be better served by a simple tcm_loo=
p LLD
>>>>> specific API for different multipath transports..?
>>>>>
>>>> Actually, I would split off the various transport functions into
>>>> separate files (tcm_loop_sas, tcm_loop_fc, etc), but keep a common
>>>> tcm_loop module.
>>>> We can even make transport classes optional by adding an explicit
>>>> 'sas.XXX' prefix scanning when creating the device similar to what
>>>> we do with the 'fc.XXX' prefix already.
>>>> With that we would have a 'sas.XXX', 'fc.XXX', and 'iqn.XXX' WWN
>>>> which would attach to the respective transport class, and any othe=
r
>>>> WWN (which would be the default) would be getting the standard
>>>> emulation without any transport class attached.
>>>
>>> I'm open to merging the tcm_loop patches #1-#6 as-is for the sas
>>> transport pieces, or wait until you've done a large split based on
>>> transport class types.
>>>
>>> It's really your call how the initial merge should look.
>>>
>> Probably leave out the transport class stuff for now; I kinda like
>> the idea of having all types of transport classes available for
>> tcm_loop.
>> But this is actually not related to the rest of the patchset, so
>> you can skip those for the time being.
>>
>=20
> Just to confirm, applying patch #3-#6, and #8 to for-next now.
>=20
> Skipping #7 for the moment, given host side expectations short of bei=
ng
> configurable as noted by HCH.
>=20
Precisely. Thank you.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
