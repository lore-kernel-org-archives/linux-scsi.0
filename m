From: "Ian P. Christian" <pookey@pookey.co.uk>
Subject: Re: Strange problems with a Megaraid RAID array on a Dell Poweredge 1850
Date: Thu, 8 Dec 2005 13:56:27 +0000
Message-ID: <200512081356.27583.pookey@pookey.co.uk>
References: <200512080118.17001.pookey@pookey.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-6
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xian.ncuk.net ([80.249.110.212]:35544 "EHLO xian.ncuk.net")
	by vger.kernel.org with ESMTP id S1751184AbVLHN4g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 08:56:36 -0500
In-Reply-To: <200512080118.17001.pookey@pookey.co.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thursday 08 December 2005 01:18, Ian P. Christian wrote:
> Basically, I can't use fdisk on /dev/sda. =A0I can however boot off t=
his
> array, and everything is working fine - I'm having no issues using th=
is
> array for anything else. A live, and apparently healthy system is run=
ning
> from it.
>
> # fdisk -l
> Unable to seek on /dev/sda

I've just installed parted and tried this - oddly, this works fine.  Wh=
y might=20
sfdisk and fdisk fail to read the partition table, but parted work fine=
?

Kind Regards,

--=20
Ian P. Christian ~ http://pookey.co.uk
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
