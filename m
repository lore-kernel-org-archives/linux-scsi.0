From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Logging of all scsi commands to a certain target?
Date: Sat, 23 Aug 2014 11:48:11 -0400
Message-ID: <53F8B7BB.3000708@interlog.com>
References: <53F8AB3F.50901@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56153 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaHWPsO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 11:48:14 -0400
In-Reply-To: <53F8AB3F.50901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 14-08-23 10:54 AM, Hans de Goede wrote:
> Hi,
>
> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
> I'm getting quite a few bug reports about issues with UAS drives.
>
> Some of these seem to be related to the scsi core and/or the sd
> driver sending a command the device does not like.
>
> As such I'm wondering if there us a way to get the kernel
> to log each scsi command ? Or at least is there a helper
> function to log scsi commands which I can add to the uas driver
> (under a verbose option) to allow this ?

Look for uses of this exported function:
     void scsi_print_command(struct scsi_cmnd *cmd)

