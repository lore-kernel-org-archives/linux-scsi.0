From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] /proc/scsi/map
Date: Sun, 23 Jun 2002 18:50:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D167AE4.1080409@pacbell.net>
References: <3D14B2CF.90002@pacbell.net> <1024769900.6875.139.camel@subjeKt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Nick Bellinger <nickb@attheoffice.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> This reiterates the need for a sound logical device naming scheme that
> fits into driverfs without mucking up the basic structure.  Not being a
> expert on naming, the least offensive format I can think with regard to
> iSCSI would be something along the lines of:
>   
> $DRIVERFS/virt/iscsi/iqn.2002-06.com.foo.super.turbo.disk.array.3543/disk0

That could do the job, but I'll leave those discussions up to SCSI
experts ... seems there are folk there who know something about the
topic, unlike me !  :)

Perhaps such things will be discussed at OLS next week, not that
I'll be there.

- Dave


