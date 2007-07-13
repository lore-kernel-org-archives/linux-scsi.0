From: Olaf Hering <olaf@aepfle.de>
Subject: PS3 Storage Driver O_DIRECT issue
Date: Fri, 13 Jul 2007 14:27:52 +0200
Message-ID: <20070713122752.GA854@aepfle.de>
References: <20070704132212.726923000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759303AbXGMM1v@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070704132212.726923000@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This driver (or the generic PS3 code) has appearently problems with
O_DIRECT. 
glibc aborts parted because the malloc metadata get corrupted. While it
is reproducible, the place where it crashes changes with every version
of the debug attempt.
I dont have a handle right now, all I know is that the metadata after a
malloc area get overwritten with zeros.


Can you have a look at this? 
parted /dev/ps3da
print (a few times)
