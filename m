From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 14 Feb 2012 10:57:43 +0100
Message-ID: <4F3A3017.4060202@redhat.com>
References: <20120213130005.GB26773@redhat.com> <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com> <20120213131848.GD26773@redhat.com> <4F39287A.9030808@suse.de> <CAN05THT=7xJhqAMrAvDsK2Z1_4d+=tV9yhOFkr5Z-i43k5hAGA@mail.gmail.com> <CAN05THT6t_w=9Zt+o-B4s8E3jUMWsxiBvTyySxNEK2QfvLe-BA@mail.gmail.com> <20120213225623.GA2988@redhat.com> <CAN05THS_zTf2VRz6QdccHbkOacnE86LNhtxp7b8twe+XezBU6Q@mail.gmail.com> <20120213233334.GC4430@redhat.com> <CAN05THTTva709Dab9f_PBWxehMWnP9Gg4T7Nnmg7Swk3xuz7aQ@mail.gmail.com> <20120214011144.GB5192@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45628 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2BNJ5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 04:57:52 -0500
In-Reply-To: <20120214011144.GB5192@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, Hannes Reinecke <hare@suse.de>, Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>

On 02/14/2012 02:11 AM, Michael S. Tsirkin wrote:
> On Tue, Feb 14, 2012 at 11:49:55AM +1100, ronnie sahlberg wrote:
>> By just exposing this device to the kernel, the kernel keeps sending,
>> or if not the kernel maybe some other process trying to poll the
>> status?
>>
>> every few seconds :
>> PREVENT_ALLOW_MEDIUM_REMOVAL  prevent removal
>> PREVENT_ALLOW_MEDIUM_REMOVAL  to immediatel change it back to allow
>> removal again
>> TEST_UNIT_READY
>>
>>
>> After I run this
>> mount /dev/sdd1 /mnt
>>
>> The kernel sends a single
>> PREVENT_ALLOW_MEDIUM_REMOVAL to prevent removal
>> then every few seconds a
>> TEST_UNIT_READY

Sorry to interrupt you again guys, but: the discussion started with 
virtio-blk hotplug and now we're talking about SCSI commands?  Sure 
somebody switched topic at some point :) and anyway this is irrelevant 
to what virtio-blk can/cannot do.

BTW, for virtio-scsi the spec provides a way to do hotplug and hotunplug 
without any polling, though it's not implemented yet in the driver.

Paolo
