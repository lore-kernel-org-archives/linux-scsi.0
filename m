From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/1] [SCSI] scsi_debug: Add "removable" parameter
Date: Thu, 06 Sep 2012 10:22:58 -0400
Message-ID: <5048B1C2.1060909@interlog.com>
References: <20120906100307.GC2864@piware.de> <20120906100433.GD2864@piware.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120906100433.GD2864@piware.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12-09-06 06:04 AM, Martin Pitt wrote:
> Add "removable" module parameter to set the "removable" attribute of any
> subsequently created debug block device. It is a writable driver option, so
> that you can switch between removable and "fixed" media block devices in
> between the add_host calls.
>
> This is useful for being able to test the different behaviour/required
> privileges in e. g. the udisks test suite.
>
> Signed-off-by: Martin Pitt <martin.pitt@ubuntu.com>
> Acked-By: David Zeuthen <zeuthen@gmail.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
