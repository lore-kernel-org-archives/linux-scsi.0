From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: dpt_i2o driver
Date: Tue, 2 Sep 2003 13:10:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA256915@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:59859 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S261221AbTIBRKc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 13:10:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

'Christoph Hellwig' [mailto:hch@infradead.org] writes:
>> Hmmm, lets just delete this (mounted) array. I want to take this
(mounted)
>> drive to expand an array's capacity. This call is used to inform the user
>> that the action that one is about to be asked to perform is being blocked
>> because it would cause damage to the operating system.
>In Linux 2.6 userspace should get hotplug events as soon as the the last
>reference is gone and the device is deleted.  As the device is freed at
>the same time you ioctl won't find it anymore anyway and thus fail..
>
>The hotplug even is picked up by the hotplug script which currently
>unfortunately are distro-specific.

The DPT application (raidutil and dpteng) sources are now public domain,
alas this looks like future development changes in this code base. The Busy
Check is picked up by dpteng for both the CLI and the GUI. Looks like this
arena is too fluid for us to count on anything or to worry about it at this
specific instant of time.

When the device is mounted, should we not have a usage count in the kernel,
or are the hotplug events clearing this? Sorry for showing my ignorance of
the hotplug needs ...

Sincerely -- Mark Salyzyn
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
'Christoph Hellwig' [mailto:hch@infradead.org] writes:
>> Hmmm, lets just delete this (mounted) array. I want to take this
(mounted)
>> drive to expand an array's capacity. This call is used to inform the user
>> that the action that one is about to be asked to perform is being blocked
>> because it would cause damage to the operating system.
>In Linux 2.6 userspace should get hotplug events as soon as the the last
>reference is gone and the device is deleted.  As the device is freed at
>the same time you ioctl won't find it anymore anyway and thus fail..
>
>The hotplug even is picked up by the hotplug script which currently
>unfortunately are distro-specific.

The DPT application (raidutil and dpteng) sources are now public domain,
alas this looks like future development changes in this code base. The Busy
Check is picked up by dpteng for both the CLI and the GUI. Looks like this
arena is too fluid for us to count on anything or to worry about it at this
specific instant of time.

When the device is mounted, should we not have a usage count in the kernel,
or are the hotplug events clearing this? Sorry for showing my ignorance of
the hotplug needs ...

Sincerely -- Mark Salyzyn
