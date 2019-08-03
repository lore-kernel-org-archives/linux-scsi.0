From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 5.2.x kernel: WD 8TB USB Drives: Unaligned partial completion
 (resid=78, sector_sz=512)
Date: Sat, 3 Aug 2019 15:00:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1908031458330.22056-100000@netrider.rowland.org>
References: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <006d01d549db$54e42140$feac63c0$@lucidpixels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 3 Aug 2019, Justin Piszcz wrote:

> Attached 2 x brand new Western Digital 8TB USB 3.0 drives awhile back and
> ran some file copy tests and was getting these warnings-- is there any way
> to avoid these warnings?  I did confirm with parted that the partition was
> aligned but this appears to be something related to the firmware on the
> device according to [1] and [2]?
> 
> [1] https://patchwork.kernel.org/patch/9573203/
> [2] https://patchwork.kernel.org/patch/9597797/

Just out of curiosity, why did you not address your email to the author 
or committer of this patch?  Surely they would be the people in the 
best position to answer your questions.

Alan Stern
