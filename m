From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE] iSCSI target implementation
Date: Thu, 16 Oct 2003 21:49:57 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F8F4AC5.7080209@pobox.com>
References: <3F8E9DA4.11ED60DA@ardistech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3F8E9DA4.11ED60DA@ardistech.com>
To: Roman Zippel <roman@ardistech.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Roman Zippel wrote:
> Anyway, while it's in the kernel, there are also some interesting issues
> for the kernel-user space communication. Right now it's a proc only
> interface (no sysfs as it's 2.4 only, no evil ioctl, but someone will
> kill me for the macro abuse :) ), but it should be rather easy to

Adding to procfs is only slightly less "ewww" than ioctls :)  A 
dedicated chrdev would be IMO preferred to procfs.

Al Viro also had even even more interesting suggestion for [zerocopy] 
kernel/userspace communication:  ramfs.

	Jeff
