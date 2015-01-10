From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] - SMR Modifications to EXT4 (and other
 generic file systems)
Date: Sat, 10 Jan 2015 14:40:32 +0100
Message-ID: <54B12BD0.4080608@suse.de>
References: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com> <54AD496B.8080708@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <54AD496B.8080708@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>, Adrian Palmer <adrian.palmer@seagate.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/07/2015 03:57 PM, Sasha Levin wrote:
> On 01/06/2015 06:29 PM, Adrian Palmer wrote:
>> I'd like to host a discussion of SMRFFS and ZAC for consumer and clo=
ud
>> systems at LSF/MM. I want to gather community consensus at LSF/MM of=
 the
>> required technical kernel changes before this topic is presented at =
Vault.
>>
>> Subtopics:
>>
>> On-disk metadata structures and data algorithms
>> Explicit in-order write requirement and a look at the IO stack
>> New IOCTLs to call from the FS and the need to know about the underl=
ying
>> disk -- no longer completely disk agnostic
>=20
> Where can we read about the details of SMRFFS before LSF/MM / Vault?
>=20
Please be aware that I've been working on a ZAC prototype, and have
applied for a session at LSF/MM.
And my paper for Vault has just been accepted (which will be a survey o=
f
existing filesystems and their suitability for SMR drives).

Can you keep me in the loop here?
Maybe we should have a joint session at LSF ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
