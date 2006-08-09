From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: [PATCH 3/3] qla4xxx: iospace_config move defn
Date: Wed, 09 Aug 2006 15:38:42 -0500
Message-ID: <20060809203842.489939@bebe.enoyolf.org>
References: <20060809182406.2021.90492.stgit@bebe.enoyolf.org> <20060809184243.2021.48891.stgit@bebe.enoyolf.org> <44DA21BE.3050506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:27850 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751328AbWHIUps
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 16:45:48 -0400
In-reply-to: <44DA236C.7050900@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org


On Wed, 09 Aug 2006 14:03:24 EDT, Mike Christie wrote:
> Mike Christie wrote:
> > 
> > Is my mailer messing up the tabs or are you (maybe the original code was
> > messed up and did not get fixed in the move)?
> > 

Wellll..

Have not been commenting on the whitespace changes.  It appears that 
some frobnication was happening, I have been silently editing leading 
spaces to tabs and stripping trailing whitespace.

Are you seeing tabs changed to spaces?  Or the other way around?  It is
possible that emacs is getting involved some, but I can easily see the
trailing whitespace. (nee '(show-trailing-whitespace t)).

There is also a vi macro to do the same.  My vi experience is too
ancient to comment about the placement in the rc of the following,
but does work for me when I have to fall back to the ubiquitous editor. 
YMMV.

~/.vimrc
...
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  highlight WhitespaceEOL ctermbg=red guibg=red
  match WhitespaceEOL /\s\+$/
endif
...

> 
> Nevermind, I switch mailers and it looks ok now. Weird, some patches
> looked ok and some did not before.
> 


