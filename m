From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Mon, 23 Nov 2009 10:06:03 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911231004030.2958-100000@iolanthe.rowland.org>
References: <20091123105440.GB15679@duck.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755318AbZKWPF7@vger.kernel.org>
In-Reply-To: <20091123105440.GB15679@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: tmhikaru@gmail.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 23 Nov 2009, Jan Kara wrote:

>   Yeah, from what you write, it looks like USB enclosure is at fault (or it
> could still be your USB controller but I doubt it).  It's still a bit
> bothering that the error reported by the drive was not properly propagated
> up to VFS. Either it's some block layer retry/ignore magic that I missed or
> we ignore errors from block layer in some place.

Is there any interest in tracking this down?  It's not hard to find out
what low-level errors are being reported and to generate them on demand
with an emulated USB disk drive.

Alan Stern
