From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: PARISC changes to drivers/scsi
Date: Mon, 11 Nov 2002 11:26:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211111627.gABGQxr18575@localhost.localdomain>
References: <willy@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA14097
	for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2002 08:27:04 -0800
In-Reply-To: Message from Matthew Wilcox <willy@debian.org>
   of "Sun, 10 Nov 2002 21:22:26 GMT." <20021110212226.A12011@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

willy@debian.org said:
> Since you guys are starting to discuss stuff pertaining to Linux/
> PARISC, I'd like to be sure you're aware of our current changes vs
> Linus' tree. I wouldn't call our current tree even remotely stable in
> 2.5, so I wasn't planning on submitting these bits.  But do feel free
> to cherrypick anything you want from this patch and incorporate it.
> If you notice any bugs, all the better; I don't think anyone one the
> PA side is paying particular attention to these drivers and changes t=
o
> SCSI that affect them at the moment.=20

The zalon changes look OK.  Unfortunately, the ncr53c8xx is a broken dr=
iver at=20
the moment (it needs to be converted to the new error handling).  I als=
o=20
believe its orphaned, so if you want to sign up to fix it...

Could you run the sym53c8xx_2 changes past G=E9rard Roudier, since I th=
ink he's=20
still maintaining that one?

Thanks,

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
