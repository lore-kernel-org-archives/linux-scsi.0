From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Sun, 07 Feb 2016 11:24:27 -0800
Message-ID: <1454873067.10001.55.camel@haakon3.risingtidesystems.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
	 <56B6C5D8.6070403@sandisk.com>
	 <1454822367.10001.38.camel@haakon3.risingtidesystems.com>
	 <56B76A7E.6080903@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56B76A7E.6080903@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2016-02-07 at 08:02 -0800, Bart Van Assche wrote:
> On 02/06/16 21:19, Nicholas A. Bellinger wrote:
> > On Sat, 2016-02-06 at 20:19 -0800, Bart Van Assche wrote:
> >> On 02/06/16 19:17, Nicholas A. Bellinger wrote:
> >>> Here is -v4 series to address the set of of LUN_RESET
> >>> active I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
> >>> recently by Quinn & Co.  This can occur during active
> >>> I/O remote port TMR LUN_RESET with multi-port LIO
> >>> configurations.
> >>
> >> Hi Nic,
> >>
> >> If I understood the purpose of this patch series correctly then this
> >> patch series is a brave attempt to fix what is also fixed by my patch
> >> called "target: Make ABORT and LUN RESET handling synchronous". Wouldn't
> >> it be better to focus on that patch instead of trying to fix the current
> >> approach in which TMR handling happens from the another context than the
> >> command processing context ?
> >>
> >
> > This statement is a gross oversimplification of the issues involved.
> >
> > If you'll recall, this was already highlighted in the context of your
> > patch here:
> >
> > http://www.spinics.net/lists/target-devel/msg11057.html
> >
> > There are a number of comments on why the bug-fix was incorrect and
> > broken, the basics of what needed to be done and in what order it should
> > happen.
> >
> > But instead of replying to the comments, this was your response:
> >
> > http://www.spinics.net/lists/target-devel/msg11542.html
> >
> > If you are authentically interested in understanding the issues
> > involved, you'll probably need to go back and comment on those topics
> > individually, instead of ignoring them.
> 
> Hi Nic,
> 
> What you write is not correct. All your review comments that made sense 
> have been addressed in the latest version of my patch 
> (http://www.spinics.net/lists/target-devel/msg11666.html).

Did you respond to the specific feedback of my email..?  No.

Did you include a change-log in the subsequent patch explaining the
changes..?  No.

If you're still not willing or able to have a technical discussion on
the specific issues involved or give feedback inline to the patch series
itself, then you are just trying to waste everyone's time.

> 
> Additionally, you haven't answered my question. My question was: why to 
> spend more energy on trying to fix the current approach if the LIO TMR 
> handling code can be simplified greatly by handling ABORT and LUN RESET 
> from the regular command execution path ?
> 

Because your patch was incorrect and broken, and you still don't seem
interested in taking the time to actually understand why that is.

Listen, Bart, I'm getting tired of your inability to have a technical
discussion of the issues.

So that said, I'm going to put down some ground rules for our future
interactions.  I expect you to:

   - Ask questions when you're unsure of a specific piece of code, 
     before attempting to push changes to re-write significant pieces 
     and spend community review cycles. 
   - Comment inline to all feedback for changes of substance.
   - Stop ignoring subsystem maintainer feedback.
   - Provide a change-log between patches for all changes of substance.

If you are genuinely interested in contributing to LIO, then these
should be a no-brainer. 

If you aren't genuinely interested in contributing to LIO, then keep
doing what you're doing.
