From: Mark Lord <kernel@start.ca>
Subject: Re: [RFC] libata-scsi: introducing SANITIZE translation
Date: Wed, 26 Oct 2016 18:44:47 -0400
Message-ID: <a38e505d-bb78-ac7c-d289-0460eef9449a@start.ca>
References: <577e843e.0a86620a.59167.ffffb899@mx.google.com>
 <1467910054.2322.7.camel@HansenPartnership.com>
 <CAGnHSE=8HEZ8AnDGjdOAhaA8f117GdbZZNhbQQOCYYM1b-8PvQ@mail.gmail.com>
 <1467998971.2343.10.camel@HansenPartnership.com>
 <CAGnHSEkLer=GRZxoc=AmS7J_oe945hSdUV2TisSuvfXdCPQ2Ow@mail.gmail.com>
 <1468025398.2390.24.camel@HansenPartnership.com>
 <CAGnHSEms1rwy7-+URRMrdggpk=_7YVijHwf1h93iBKW7zLxh8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3.start.ca ([64.140.120.243]:46092 "EHLO mail3.start.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932707AbcJZWyJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 18:54:09 -0400
In-Reply-To: <CAGnHSEms1rwy7-+URRMrdggpk=_7YVijHwf1h93iBKW7zLxh8g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 16-07-11 02:35 AM, Tom Yan wrote:
> I don't suppose there would be any problem doing it in userspace /
> with ATA PASS-THROUGH anyway.
..
>>> On 8 July 2016 at 17:29, James Bottomley
>>> <James.Bottomley@hansenpartnership.com> wrote:
..
>> Not really.  The point is that you've proposed something as an addition
>> to the kernel that can also be done in userspace.  Checking if it can
>> work easily there is like a barrier to entry.  If it works, then fine,
>> we're done.  If it throws up problems then we reconsider the kernel
>> route.

hdparm has full support for the SANITIZE commands in userspace.

-ml
