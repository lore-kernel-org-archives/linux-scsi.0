From: <alexey@technomagesinc.com>
Subject: Re: hot scsi disk resize
Date: 04 Mar 2003 12:42:18 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m31y1n8o3p.fsf@lexa.home.net>
References: <m3bs0s9xij.fsf@lexa.home.net> <3E64727C.9040204@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E64727C.9040204@cri74.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, alexey@technomagesinc.com, Dennis Gerasimov <denis@technomagesinc.com>

>>>>> Fabien Salvi (FS) writes:

 FS> Well, I also think it's a very important and needed feature for
 FS> HA systems.  I'm very interested in such things...

 FS> But, I thought resize_reiserfs only resize *unmounted* filesystem
 FS> : http://www.reiserfs.org/resize_reiserfs.html

citate from this URL: "The resize_reiserfs program allows to grow a
reiserfs on-line if there is a free space on block device."

 FS> Will it work under IO load ?

I tested it several times under different load (read-only, write-only,
read-write, single-thread and multi-thread tests). I think reiserfs
team may give comments.


 FS> Reiserfs has a way to do it dynamically while using it, with
 FS> mount option : http://www.reiserfs.org/mount-options.html

 FS> I've tested this without a lot of success (I encounter a lot of
 FS> problems).

what kind of problem have you seen? what versions of kernel/reiserfs/tools?

 FS> I'm afraid that even if scsi subsystem support the resize option,
 FS> FileSystems won't support it correctly...  Maybe with LVM ?

 FS> Did someone test it ?

>From filesystem point of view, LVM and resizable SCSI HDD are the same
think - just block device which may grow.

I think this patch is just one more step in the right direction.


