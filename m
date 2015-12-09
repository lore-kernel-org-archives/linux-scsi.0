From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 16:45:12 +0300
Message-ID: <20151209134512.GA5177@mwanda>
References: <55B9CA3B.1030205@suse.de>
 <20151209102453.GE3173@mwanda>
 <20151209115339.46a09d94@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151209115339.46a09d94@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Ondrej Zary <linux@rainbow-software.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Everyone knows I didn't test it but it's an obvious one line fix for
memory corruption.  If no one uses the code, at least this is harmless
and silences a static checker warning.

In olden times we used to say, "Oh this bounds checking is crap but it's
root only so let's leave it alone."  But these days we just fix it.
It's easier to just fix everything instead of trying to decide which
bugs are critical.

regards,
dan carpenter
