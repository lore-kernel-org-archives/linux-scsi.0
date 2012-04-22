From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 11/12] libsas: fix false positive 'device attached' conditions
Date: Sun, 22 Apr 2012 08:56:10 -0700
Message-ID: <CABE8wwsgRXZdFRW3Zket7=6QtUSmRZ_uxzUs-QtWun-edpROPA@mail.gmail.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	<20120413233747.8025.13302.stgit@dwillia2-linux.jf.intel.com>
	<1335092017.13208.15.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1335092017.13208.15.camel@dabdike.lan>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-ide@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@intel.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Apr 22, 2012 at 3:53 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
>> Normalize phy->attached_sas_addr to return a zero-address in the cas=
e
>> when device-type =3D=3D NO_DEVICE or the linkrate is invalid to hand=
le
>> expanders that put non-zero sas addresses in the discovery response:
>>
>> =A0sas: ex 5001b4da000f903f phy02:U:0 attached: 0100000000000000 (no=
 device)
>> =A0sas: ex 5001b4da000f903f phy01:U:0 attached: 0100000000000000 (no=
 device)
>> =A0sas: ex 5001b4da000f903f phy03:U:0 attached: 0100000000000000 (no=
 device)
>> =A0sas: ex 5001b4da000f903f phy00:U:0 attached: 0100000000000000 (no=
 device)
>>
>> Reported-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> This should be flagged for stable, shouldn't it?

Probably should yes... would be nice to not need to rebase to append a
Cc:.  So far I have the impression we could handle the review comments
with appending a new commit or two.  So If I can keep the commit ids
stable I'll just flag this one to stable@ once it goes upstream.

--
Dan
