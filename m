From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 21 Dec 2002 13:41:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021221.134133.123990503.davem@redhat.com>
References: <223910000.1040435985@aslan.btc.adaptec.com>
	<1040443851.1441.0.camel@rth.ninka.net>
	<4085892704.1040483953@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <4085892704.1040483953@aslan.scsiguy.com>
To: gibbs@scsiguy.com
Cc: wli@holomorphy.com, janetmor@us.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

   From: "Justin T. Gibbs" <gibbs@scsiguy.com>
   Date: Sat, 21 Dec 2002 08:19:13 -0700
   
   I think that if you look here, I put more information
   into BK than most people.

When I read you say that you split the changesets into individual
precise changes in perforce, and you're not willing to translate
that into individual BK changesets, that is what makes me say
that you aren't using the tool properly.

Have a look at my changesets sometime, Justin.  Just adding a missing
include, that's a changeset.  That's the kind of thing I look for, and
when I get more changes than that in a patch I have to integrate, I
tend to cringe.
