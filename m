From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Wed, 18 Jan 2012 14:58:08 -0800
Message-ID: <20120118225808.GA3074@tux1.beaverton.ibm.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com> <20120117200609.GA7933@redhat.com> <20120117213648.GA9457@quack.suse.cz>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120117213648.GA9457@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 17, 2012 at 10:36:48PM +0100, Jan Kara wrote:
> On Tue 17-01-12 15:06:12, Mike Snitzer wrote:
> > 5) Any more progress on stable pages?
> >    - I know Darrick Wong had some proposals, what remains?
>   As far as I know this is done for XFS, btrfs, ext4. Is more needed?

Yep, it's done for those three fses.

I suppose it might help some people if instead of wait_on_page_writeback we
could simply page-migrate all the processes onto a new page...?

Or possibly modify md-raid5 not to snapshot dirty pages prior to xor/write?
(I never really bothered to find out if it really does this.)

--D
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

