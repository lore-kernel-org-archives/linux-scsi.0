From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Serial ATA (SATA) for Linux status report
Date: Sun, 18 Jan 2004 13:00:26 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <400AC9BA.1020103@pobox.com>
References: <20031203204445.GA26987@gtf.org> <200401181432.55736.adasi@kernel.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200401181432.55736.adasi@kernel.pl>
To: Witold Krecicki <adasi@kernel.pl>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Witold Krecicki wrote:
> Dnia Wednesday 03 of December 2003 21:44, Jeff Garzik napisa=B3:
>=20
>>Editor's preface:  This is clearly a first draft, only covering the
>>basics.  In order for this document to be effective, I request that
>>users and developers send me (or post) their SATA driver questions an=
d
>>issues.  I will do my best to address them here.
>>
>>
>>Serial ATA (SATA) for Linux
>>status report
>>Dec 3, 2003
>=20
> What about SMART capabilities? with sii3112 I had it, but with libata=
 I cannot=20
> get any informations :/


Currently do not support random userland programs throwing random ATA=20
commands at us...  so no SMART support at present :)  It's coming, thou=
gh.

	Jeff
