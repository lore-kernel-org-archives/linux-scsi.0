From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Wed, 25 Jan 2006 23:26:40 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0601252315340.5794@kai.makisara.local>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.63.0601242245260.6350@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:6040 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932107AbWAYVYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 16:24:35 -0500
In-Reply-To: <Pine.LNX.4.63.0601242245260.6350@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Kai Makisara wrote:

...
> One thing that can affect your comparisons is that the amount of data is 
> quite small compared to the drive speed. The startup delay may be a 
> significant factor in the timings (it differs depending on where the tape 
> is and what has happened before the test). Even taking this into account, 
> the speeds you see with 2.6 are too small.
> 
I think I said this too weakly ;-) If you want to measure the streaming 
speed of the tape system, the test file must be large enough. It can take 
tens of seconds before a streamer starts writing and this time does vary 
depending on the tape position, tape, has the drive been reading/writing 
before, etc. You can verify this i you can listen what the drive is doing 
during the tests. You can also try writing very small files and measure 
the times.

A rule of thumb might be to have a test data that takes one or more
minutes to read/write. The HP LTO-3 raw speed is 80 MB/s without 
compression. So, for a one minute test you should have 800 MB of 
uncompressible data (or switch compression off).

-- 
Kai
