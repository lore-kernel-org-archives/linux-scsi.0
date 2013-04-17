From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 14/28] proc: Supply an accessor for getting the data from
 a PDE's parent [RFC]
Date: Tue, 16 Apr 2013 18:01:04 -0700
Message-ID: <20130417010104.GF11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182646.27773.40149.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130416182646.27773.40149.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>, linux-scsi@vger.kernel.org, Jerry Chuang <jerry-chuang@realtek.com>, linux-wireless@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>, Maxim Mikityanskiy <maxtram95@gmail.com>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 16, 2013 at 07:26:46PM +0100, David Howells wrote:
> Supply an accessor function for getting the private data from the parent
> proc_dir_entry struct of the proc_dir_entry struct associated with an inode.
> 
> ReiserFS, for instance, stores the super_block pointer in the proc directory
> it makes for that super_block, and a pointer to the respective seq_file show
> function in each of the proc files in that directory.
> 
> This allows a reduction in the number of file_operations structs, open
> functions and seq_operations structs required.  The problem otherwise is that
> each show function requires two pieces of data but only has storage for one
> per PDE (and this has no release function).
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jerry Chuang <jerry-chuang@realtek.com>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> cc: linux-wireless@vger.kernel.org
> cc: linux-scsi@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
