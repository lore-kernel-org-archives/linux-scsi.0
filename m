From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 6 Oct 2004 15:58:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041006145821.GD16153@parcelfarce.linux.theplanet.co.uk>
References: <BC3CE0375D29D51199A400508B66CA6C0862AEFF@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30088 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269277AbUJFO62
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 10:58:28 -0400
Content-Disposition: inline
In-Reply-To: <BC3CE0375D29D51199A400508B66CA6C0862AEFF@exc-snake.co.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, "'arjanv@redhat.com'" <arjanv@redhat.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Oct 06, 2004 at 08:46:11AM -0600, Gibbons, Terry wrote:
> I was copied because the very people that will resolve the issue, namely
> Eric and Larry, included me as to bring support to their position that they
> have a BIG problem and solutions aren't being mutually agreed upon.
> 
> Therefore, I'm the one chosen to take the unpopular stance of challenging
> the status quo and asking for solutions as opposed to pushback on every
> stance LSI has put forth.

All I said was:

> Of course, at some point, Fusion should be switched over to use the
> scsi_transport_spi domain validation code ... not urgent, just an
> item for the long-term todo list.

I see the remainder of the thread as being pushback from _LSI_ on the
direction that the rest of the SCSI people have decided to go.
If you're not part of the solution ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
