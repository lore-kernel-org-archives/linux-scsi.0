From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: IDs
Date: Mon, 6 Jan 2003 19:15:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106191522.A11624@beaverton.ibm.com>
References: <UTC200301070219.h072JjD19965.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200301070219.h072JjD19965.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Tue, Jan 07, 2003 at 03:19:45AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net, zwane@holomorphy.com

On Tue, Jan 07, 2003 at 03:19:45AM +0100, Andries.Brouwer@cwi.nl wrote:
> > We can tell if the id sdev->name should be unique by looking at
> > the first byte (it is not unique if the value is 'Z'),
> > SCSI_UID_UNKNOWN.
> 
> Such things are nontrivial.

Yes ...

> And where we have heuristics only, it cannot be "wrong"
> to truncate at 50 positions or so. The heuristic does
> not become appreciably weaker.

But, we don't have to truncate, we should just allocate as many bytes as
we need, and store the information.

And, the sysfs name should not store the id.

-- Patrick Mansfield
