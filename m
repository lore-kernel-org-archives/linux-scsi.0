From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/10] staging: fnic2 add initialization
Date: Mon, 09 Apr 2018 16:57:16 -0400
Message-ID: <yq1r2no3xoz.fsf@oracle.com>
References: <20180405211519.GA12584@osmithde-lnx.cisco.com>
        <20180405211644.GB12584@osmithde-lnx.cisco.com>
        <20180406050752.GC27591@kroah.com>
        <20180406220010.GA23478@osmithde-lnx.cisco.com>
        <20180407060901.GA18744@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180407060901.GA18744@kroah.com> (Greg Kroah-Hartman's message
        of "Sat, 7 Apr 2018 08:09:01 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Smith-Denny <osmithde@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Gian Carlo Boffa <gcboffa@cisco.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Greg,

>> If you think that this driver doesn't belong in the drivers/staging
>> community, we are happy to explore getting the driver fully ready on
>> our side and getting it into the "proper" place.
>
> I'll take anything in staging as long as it has the correct license and
> builds, that's not an issue :)  But I do want to get agreement from the
> SCSI maintainers that this is ok to have in this part of the kernel as
> sometimes it can cause merge issues if there are core api changes.

This is the first I hear of fnic2.

My initial questions are: Why is a new driver necessary? Why can't the
existing fnic driver be extended? And if it can't, what can be shared
between the two drivers?

A good place to have that discussion would be on linux-scsi...

-- 
Martin K. Petersen	Oracle Linux Engineering
