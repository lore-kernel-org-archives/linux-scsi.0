From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 9/9] isci: add version number
Date: Mon, 1 Aug 2011 09:24:33 -0700
Message-ID: <CAA9_cmfnSVdohf5bkfXjZvsa+O2vjvVdy2RA=f2EfVYeXdkX+Q@mail.gmail.com>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
	<20110730001721.28430.28086.stgit@localhost6.localdomain6>
	<20110730185507.7b68c0a7@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62931 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1HAQYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 12:24:33 -0400
Received: by pzk37 with SMTP id 37so11760751pzk.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2011 09:24:33 -0700 (PDT)
In-Reply-To: <20110730185507.7b68c0a7@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Sat, Jul 30, 2011 at 9:55 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Jul 29 Dan Williams wrote:
>> @@ -540,7 +548,8 @@ static __init int isci_init(void)
>> =A0{
>> =A0 =A0 =A0 int err;
>>
>> - =A0 =A0 pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_N=
AME);
>> + =A0 =A0 pr_info("%s: Intel(R) C600 SAS Controller Driver - version=
 %s\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 DRV_NAME, DRV_VERSION);
>
> Why? =A0There is already a version number. =A0Like 2.6.39, 3.0, 3.1.

This is for tracking driver versions across distributions and driver
update packages as they sync with upstream on different cadences.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
