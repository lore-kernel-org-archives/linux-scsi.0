From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 16:55:28 +0200
Message-ID: <4D934460.1000302@suse.de>
References: <1301373398.2590.20.camel@mulgrave.site>	 <4D91BF90.8070909@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659CFFED@BLRX7MCDC203.AMER.DELL.COM>	 <20110329173338.GD24485@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>	 <20110329184501.GG24485@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D0033@BLRX7MCDC203.AMER.DELL.COM>	 <20110329195953.GD21671@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D004B@BLRX7MCDC203.AMER.DELL.COM>	 <20110329202353.GG21671@redhat.com>	 <DBFB1B45AF80394ABD1C807E9F28D15702659D00AB@BLRX7MCDC203.AMER.DELL.COM>	 <4D92C691.9070607@suse.de> <1301493722.2618.1.camel@mulgrave.site>	 <4D9339D3.50500@suse.de> <1301495212.2618.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab1C3Ozn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 10:55:43 -0400
In-Reply-To: <1301495212.2618.11.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Shyam_Iyer@dell.com, linux-scsi@vger.kernel.org, lsf@lists.linux-foundation.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com

On 03/30/2011 04:26 PM, James Bottomley wrote:
> On Wed, 2011-03-30 at 16:10 +0200, Hannes Reinecke wrote:
>> On 03/30/2011 04:02 PM, James Bottomley wrote:
>>> On Wed, 2011-03-30 at 07:58 +0200, Hannes Reinecke wrote:
>>>> No, seriously. I think it would be good to have a separate slot
>>>> discussing DCB (be it FCoE or iSCSI) and cgroups.
>>>> And how to best align these things.
>>>
>>> OK, I'll go for that ... Data Centre Bridging; experiences, technol=
ogies
>>> and needs ... something like that.  What about virtualisation and o=
pen
>>> vSwitch?
>>>
>> Hmm. Not qualified enough to talk about the latter; I was more
>> envisioning the storage-related aspects here (multiqueue mapping,
>> QoS classes etc). With virtualisation and open vSwitch we're more in
>> the network side of things; doubt open vSwitch can do DCB.
>> And even if it could, virtio certainly can't :-)
>
> Technically, the topic DCB is about Data Centre Ethernet enhancements
> and converged networks ... that's why it's naturally allied to virtua=
l
> switching.
>
> I was thinking we might put up a panel of vendors to get us all an
> education on the topic ...
>
Oh, but gladly.
Didn't know we had some at the LSF.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
