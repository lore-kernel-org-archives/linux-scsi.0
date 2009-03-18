From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/3] scsi_dh: Change scsi device handler modules to
	utilize modalias
Date: Wed, 18 Mar 2009 19:18:56 +0100
Message-ID: <ac3eb2510903181118h7a28e0a2m88aa62cbf68f0fe8@mail.gmail.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013627.26548.27704.sendpatchset@chandra-ubuntu>
	 <20090318134629.GB19448@mars.virtualiron.com>
	 <49C1168F.6060900@s5r6.in-berlin.de>
	 <1237397158.14147.3.camel@chandra-ubuntu>
	 <49C1344D.30502@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:44958 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbZCRSTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 14:19:00 -0400
Received: by nf-out-0910.google.com with SMTP id d21so34010nfb.21
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 11:18:57 -0700 (PDT)
In-Reply-To: <49C1344D.30502@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: sekharan@linux.vnet.ibm.com, Konrad Rzeszutek <konrad@virtualiron.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@hansenpartnership.com

On Wed, Mar 18, 2009 at 18:50, Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
> Chandra Seetharaman wrote:
>> On Wed, 2009-03-18 at 16:43 +0100, Stefan Richter wrote:
>>> AFAICS you could have kept the check for .vendor !=3D NULL instead =
of
>>> .vendor[0] !=3D '\0' and write the terminator thusly:
>>>
>>> =C2=A0 =C2=A0 =C2=A0{},
>>>
>>> Saves the space for a one byte long string in the object files. =C2=
=A0:-)
>>
>> Tried it after your response. Got a panic :(.

It's a static char array not a pointer to a string.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
