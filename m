From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: Kill SCSI_BH
Date: Sun, 16 Jun 2002 16:32:44 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206161631110.26335-100000@waste.org>
References: <20020616040111.P9435@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020616040111.P9435@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 16 Jun 2002, Matthew Wilcox wrote:

> I'm not exactly clueful about the linux SCSI layer, but I'd really like
> to see old-style bottom halves die before 2.6.  Is there any reason why
> SCSI_BH can't simply be comverted to a tasklet?

Very nice.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.."

