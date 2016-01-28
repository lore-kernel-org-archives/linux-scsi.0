From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re: st driver doesn't seem to grok LTO partitioning
Date: Thu, 28 Jan 2016 21:56:58 +0200
Message-ID: <B1700926-AD0E-4282-950B-D3CDBF0942B6@kolumbus.fi>
References: <20151218170644.24167419@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net> <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr> <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net> <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi> <77882221.9950832.1454008883494.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:47050 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966388AbcA1T5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 14:57:07 -0500
In-Reply-To: <77882221.9950832.1454008883494.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Shane M Seymour <shane.seymour@hpe.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, linux-scsi@vger.kernel.org


> On 28.1.2016, at 21.21, Laurence Oberman <loberman@redhat.com> wrote:
> 
> Hi Kai
> 
> What kernel was the last patch you attached against.
> 
It was against the latest git version from Jan 24 evening (Finnish time). It is 4.4.0 plus
from 4.5 merge window. The patch applies to 3.18.25 with offsets and should apply to
anything between these.

Kai

