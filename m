From: raray@jam.rr.com
Subject: Re: SCSI HBA in wrong order
Date: Fri, 9 Jul 2004 14:30:56 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407091417080.16287@rray1.jam.rr.com>
References: <OF6EBED15C.7C0610C9-ON88256ECC.00609EC2-88256ECC.00611D8B@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-04.texas.rr.com ([24.93.47.43]:55946 "EHLO
	ms-smtp-04.texas.rr.com") by vger.kernel.org with ESMTP
	id S265799AbUGITbe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 15:31:34 -0400
In-Reply-To: <OF6EBED15C.7C0610C9-ON88256ECC.00609EC2-88256ECC.00611D8B@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

I did a bit of reading about udev and I'm uncertain how this will help.
At present running RH 9.0 and 2.4.23 kernel the 2 internal harddrives are
mapped as sda and sdb.
The os is on sda and sdb is a mirror of sda.
If udev runs in user space the os has to be loaded.
Using the 2.6.6 kernel the 2 internal drive get mapped as sdg and sdh.
I've never used udev before and this is just a preliminary assessment.
I'll continue to dig for info.
Maybe You can explain a bit more.

Thanks
Richard Ray



On Fri, 9 Jul 2004, Bryan Henderson wrote:

> >> I upgraded one server to Fedora Core 2 with 2.6.6 kernel.
> >> Now Linux assigns the built in HBAs as scsi2 and scsi3 and assigns the
> >> LSIU40HVD as scsi0 and scsi1.
> >> This really screws things up.
> >
> >There is no way to fix this.
>
> It's worth mentioning that the broader problem -- that of things getting
> really screwed up by such a reversal -- can be fixed by using another way,
> such as udev, instead of the Linux host number to identify the devices.
> Which is why this "unfixable" problem has been accepted.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
