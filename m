From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 16:48:46 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309221643240.677-100000@ida.rowland.org>
References: <UTC200309221956.h8MJucs21996.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8196 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263297AbTIVUsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 16:48:47 -0400
In-Reply-To: <UTC200309221956.h8MJucs21996.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, david-b@pacbell.net, greg@kroah.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, patmans@us.ibm.com, torvalds@osdl.org

On Mon, 22 Sep 2003 Andries.Brouwer@cwi.nl wrote:

> I have seen proposals around here for flags that are far too specific
> (like "do not ask for mode page 8"). If we go to that level of detail
> then we'll soon have fifty flags.
> Black lists, and flags that describe various ways of being broken
> are a bad idea in my opinion. I will not deny that they may be needed
> in some cases, but they are never the preferred solution.
> 
> Also "conservative mode" sounds like a flag that describes some
> way of being broken.
> 
> On the other hand "hot-pluggable" describes a positive asset,
> and if we can conclude from that that it is unnecessary to ask
> for mode page 8 then we achieve the same effect in a positive way.

Bravo! a capital plan!

(Does anybody remember _Utopia Limited_ these days?)

I will be just as pleased as the next man to see these little flags go 
away -- or rather, not arrive in the first place.  And as Andries says, 
there's no real point in trying to determine the cache type for a 
hot-pluggable device in the first place.  Furthermore, this will get rid 
of some annoying "Can't SYNCHRONIZE" messages from sd.c.

Alan Stern

