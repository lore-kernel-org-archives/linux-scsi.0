From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI trees, merges and git status
Date: Mon, 18 Apr 2005 18:14:51 -0500
Message-ID: <1113866092.4998.92.camel@mulgrave>
References: <1113856118.4998.70.camel@mulgrave>
	 <Pine.LNX.4.58.0504181429570.15725@ppc970.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <git-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0504181429570.15725@ppc970.osdl.org>
Sender: git-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: git@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-04-18 at 14:39 -0700, Linus Torvalds wrote:
> > Linus, the rc-fixes repo is ready for applying ... it's the same one I
> > announced on linux-scsi and lkml a while ago just with the git date
> > information updated to be correct (the misc one should wait until after
> > 2.6.12 is final).
> 
> Ok. Can you verify? I did a "git diff" between your old head and my new
> head, and it did not show any SCSI files (only the expected arm etc stuff
> that you didn't have in your), so it all _looks_ good. But hey, just to
> make sure that I didn't do anything stupid..

Actually, the verify fails, according to bitkeeper.

It looks like the merge tree has contamination from the scsi-misc-2.6
tree ... possibly because the hosting system got the merged objects when
I pushed.

Could you strip it back and I'll check out the repos on www.parisc-
linux.org?

Thanks,

James


