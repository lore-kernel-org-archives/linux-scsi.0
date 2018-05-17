From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 11/40] ipv6/flowlabel: simplify pid namespace lookup
Date: Thu, 17 May 2018 14:14:57 -0500
Message-ID: <87efiahz66.fsf@xmission.com>
References: <20180425154827.32251-1-hch@lst.de>
        <20180425154827.32251-12-hch@lst.de> <878t8y46sy.fsf@xmission.com>
        <20180515145643.GA661@lst.de> <871seakg0u.fsf@xmission.com>
        <20180517064220.GA24300@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517064220.GA24300@lst.de> (Christoph Hellwig's message of
        "Thu, 17 May 2018 08:42:20 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Thu, May 17, 2018 at 12:28:01AM -0500, Eric W. Biederman wrote:
>> > struct pid_namespace *proc_pid_namespace(struct inode *inode)
>> > {
>> > 	// maybe warn on for s_magic not on procfs??
>> > 	return inode->i_sb->s_fs_info;
>> > }
>> 
>> That should work.  Ideally out of line for the proc_fs.h version.
>> Basically it should be a cousin of PDE_DATA.
>
> The version in Al's tree is inline and without the warning as
> I didn't want to drag in the magic.h include.  Please look at it for
> additional comments, I can send incremental fixups if needed.

Sounds good.

Eric
