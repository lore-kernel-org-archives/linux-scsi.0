From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 12:52:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106125243.A9710@beaverton.ibm.com>
References: <UTC200301052142.h05LgkH25404.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200301052142.h05LgkH25404.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Sun, Jan 05, 2003 at 10:42:46PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: zwane@holomorphy.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net

On Sun, Jan 05, 2003 at 10:42:46PM +0100, Andries.Brouwer@cwi.nl wrote:
> Zwane Mwaikambo writes:
> 
> > This looks related to something i also bumped into
> >
> > scsi scan: host 2 channel 0 id 0 lun 0 identifier too long
> 
> Sounds familiar. Please try the below (on 2.5.54).
> 
> Andries
> 

Instead of truncating the id, we need a new scsi_uid field allocated
to whatever size required. And, a descriptive string put in the name,
rather than the id, such as:

    scsi disk
    scsi processor
    scsi tape 

Even if the id is truncated, that information has to be available.

-- Patrick Mansfield
