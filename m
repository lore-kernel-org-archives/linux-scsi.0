From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] merge sd.h into sd.c and some cleanup
Date: Sun, 27 Oct 2002 14:51:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027145142.A20218@infradead.org>
References: <20021026031850.A5491@lst.de> <3DBBCC5B.50708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DBBCC5B.50708@torque.net>; from dougg@torque.net on Sun, Oct 27, 2002 at 10:22:03PM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sun, Oct 27, 2002 at 10:22:03PM +1100, Douglas Gilbert wrote:
> The patch looks good. However ....
> The header file "sd.h" is included in quite a few lower level
> drivers in lk 2.5.44 (at least 55) and perhaps in a couple of
> other subsystems. The reason it is included is for the
> "biosparam" call in the API of lower level drivers. Whether
> it is still used or useful, I'm not sure. [It does seem
> quite unreasonable that lower level drivers need to include
> an upper level header.]

I've changed the biosparm API in the scsi BK tree, against which this
patch is (see http://linux-scsi.bkbits.net)

> You can drop my credit line (shown above) from sd.c . Perhaps
> James could make a "credits" file for everyone who has helped
> in the 2.5 scsi rework.

I think it's fine to keep it - I just had to shorten it to fit into
a ANSI terminal :)

