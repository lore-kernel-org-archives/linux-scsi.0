From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Move scsi.h, hosts.h to include/linux/scsi ?
Date: Mon, 17 Feb 2003 14:18:52 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217141852.A26434@infradead.org>
References: <20030216211422.GD8572@mars.ravnborg.org> <20030217121840.A24543@infradead.org> <20030217125334.GA3346@mars.ravnborg.org> <20030217125821.A25189@infradead.org> <20030217130756.GA3510@mars.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030217130756.GA3510@mars.ravnborg.org>; from sam@ravnborg.org on Mon, Feb 17, 2003 at 02:07:56PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org

On Mon, Feb 17, 2003 at 02:07:56PM +0100, Sam Ravnborg wrote:
> As I wrote in the previous mail, I'm not going to do any split-up as
> you suggested. Simply because it would take much more time
> understanding the SCSI subsystem than actually doing the split-up.

I didn't want to dump it on you :)

> My only incentive is to avoid those ugly includes that requires an
> extra option to gcc in my current kbuild patch for separate objdir.

*nod*

