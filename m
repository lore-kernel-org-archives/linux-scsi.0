From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17][trivial] scsi: Remove unnecessary casts of void
 ptr returning alloc function return values
Date: Thu, 20 Jan 2011 08:29:22 +0100
Message-ID: <4D37E452.7030404@suse.de>
References: <alpine.LNX.2.00.1011082334400.23697@swampdragon.chaosbits.net> <alpine.LNX.2.00.1101191526410.26685@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1101191526410.26685@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 01/19/2011 03:27 PM, Jiri Kosina wrote:
> On Tue, 9 Nov 2010, Jesper Juhl wrote:
>=20
>> Hi,
>>
>> The [vk][cmz]alloc(_node) family of functions return void pointers w=
hich
>> it's completely unnecessary/pointless to cast to other pointer types=
 since
>> that happens implicitly.
>>
>> This patch removes such casts from drivers/scsi/
>>
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>\
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
