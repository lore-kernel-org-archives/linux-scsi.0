From: "David S. Miller" <davem@redhat.com>
Subject: Re: Aic7xxx 6.2.28 and Aic79xx 1.3.0 Released
Date: Thu, 23 Jan 2003 20:27:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123.202727.102788332.davem@redhat.com>
References: <694670000.1043380598@aslan.scsiguy.com>
	<20030123.195327.107011605.davem@redhat.com>
	<739810000.1043382396@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <739810000.1043382396@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: gibbs@scsiguy.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@transmeta.com, alan@lxorguk.ukuu.org.uk, marcelo@conectiva.com.br

   From: "Justin T. Gibbs" <gibbs@scsiguy.com>
   Date: Thu, 23 Jan 2003 21:26:36 -0700

   > Because it is your duty as maintainer to watch what changes
   > (especially build fixes) go into Linus's and Marcelo's tree.
   
   That's like saying that its Linus's or Marcelo's responsibility
   to catch whether you or anyone else submits a bogus/broken change
   to their tree.

Your driver update broke the build of Linus's tree, so I sent Linus
a change that fixed the build.

And in fact, you are describing exactly what Linus and Marcelo's
jobs are, to reject bogus/broken changes.
