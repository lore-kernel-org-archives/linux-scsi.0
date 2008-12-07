From: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 21:07:32 -0800
Message-ID: <86802c440812062107h37f0d9f1w1304c4f0ab6856ec@mail.gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	 <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com>
	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>
	 <493B022B.3050406@ru.mvista.com> <493B0A8E.7000506@garzik.org>
	 <493B0DF2.4090901@ru.mvista.com> <493B0F36.6030509@garzik.org>
	 <86802c440812061936v4629857ehbd2705e389e4378b@mail.gmail.com>
	 <493B4E52.6080905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493B4E52.6080905@garzik.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 6, 2008 at 8:17 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> anyone one is building block layer for USB disk? will get /dev/uda?
>
> That already exists -- drivers/block/ub   :)

this one ?

config BLK_DEV_UB
        tristate "Low Performance USB Block driver"
        depends on USB
        help
          This driver supports certain USB attached storage devices
          such as flash keys.

          If you enable this driver, it is recommended to avoid conflicts
          with usb-storage by enabling USB_LIBUSUAL.

          If unsure, say N.

I was thinking it should be more faster with less one layer.

YH
