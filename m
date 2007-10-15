From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 19:06:20 +1000
Message-ID: <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com>
References: <200710112011.22000.rob@landley.net>
	 <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org>
	 <200710150304.00901.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:23235 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbXJOJGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 05:06:22 -0400
Received: by py-out-1112.google.com with SMTP id u77so2881146pyb
        for <linux-scsi@vger.kernel.org>; Mon, 15 Oct 2007 02:06:21 -0700 (PDT)
In-Reply-To: <200710150304.00901.rob@landley.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On 10/15/07, Rob Landley <rob@landley.net> wrote:
> I note that the eth0 and eth1 names are dynamically assigned on a first come
> first serve basis (like scsi).  This never causes me a problem because the
> driver loading order is constant, and once you figure out that eth0 is
> gigabit and eth1 is the 80211g it _stays_ that way across reboots, reliably.
> Yeah, it's a heuristic.  Hands up everybody relying on such a heuristic in
> the real world.

Umm, not quite, from my experiences with pre-production wireless
drivers, (another story, another time) fancy stuff is being done in
udev to make sure that your gigabit card is always assigned to eth0.

-- 

Julian Calaby

Email: julian.calaby@gmail.com
